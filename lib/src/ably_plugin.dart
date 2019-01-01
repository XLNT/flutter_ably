import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import './utils/uuid.dart';
import './utils/filters.dart';
import './models/models.dart';
import './packets/packets.dart';

const String methodChannelName = 'ably';

class AblyPlugin {
  final MethodChannel _channel = const MethodChannel(methodChannelName);
  final Map<String, Client> _clients = {};

  PublishSubject<MethodCall> _inCalls;
  Observable<MethodCall> calls;

  Observable<MessagePacket> allMessagePackets;
  Observable<ChannelStateChangePacket> allChannelStateChangePackets;

  AblyPlugin() {
    _inCalls = PublishSubject<MethodCall>();
    _channel.setMethodCallHandler((MethodCall call) async {
      _inCalls.add(call);
    });
    // ^ forward all callback handles into the publish subject

    calls = _inCalls.distinct();

    allMessagePackets = calls //
        .where(methodIs("Realtime::RealtimeChannel#onMessage"))
        .map((MethodCall call) => MessagePacket.fromJson(call.arguments))
        .doOnData((MessagePacket messagePacket) {
      print(
          "AblyPlugin: Realtime::RealtimeChannel#onMessage: from: ${messagePacket.message.clientId}, data: ${messagePacket.message.data}");
    });
    allChannelStateChangePackets = calls //
        .where(methodIs("Realtime::RealtimeChannel#onChannelStateChange"))
        .map((MethodCall call) => ChannelStateChangePacket.fromJson(call.arguments))
        .doOnData((ChannelStateChangePacket channelStateChangePacket) {
      print(
          "AblyPlugin: Realtime::RealtimeChannel#onChannelStateChange: id: ${channelStateChangePacket.channelId} ${channelStateChangePacket.stateChange.previous} --> ${channelStateChangePacket.stateChange.current}");
    });
  }

  void dispose() {
    _inCalls.close();
  }

  Future<Realtime> newRealtime() async {
    final String clientId = uuid();

    final messagePackets = allMessagePackets //
        .where(clientIs(clientId))
        .share();

    final channelStateChangePackets = allChannelStateChangePackets //
        .where(clientIs(clientId))
        .share();

    _clients[clientId] = Realtime(
      id: clientId,
      channel: _channel,
      messagePackets: messagePackets,
      channelStateChangePackets: channelStateChangePackets,
    );

    return _clients[clientId];
  }

  Future<void> disposeRealtime(String clientId) async {
    try {
      await _clients[clientId]?.dispose();
    } finally {
      _clients.remove(clientId);
    }
  }
}
