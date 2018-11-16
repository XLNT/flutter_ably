import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import './utils/uuid.dart';

import './envelope_message.dart';
import './envelope_channel_state_change.dart';
import './envelope_channel_message.dart';

import './channel_state_change.dart';
import './channel_state.dart';
import './channel_message.dart';
import './client.dart';
import './realtime.dart';

const String methodChannelName = 'ably';
bool Function(MethodCall) methodIs(String methodName) =>
    (MethodCall call) => call.method == methodName;
bool Function(EnvelopeMessage) clientIs(String clientId) =>
    (EnvelopeMessage clientMessage) => clientMessage.clientId == clientId;

class AblyPlugin {
  final MethodChannel _channel = const MethodChannel(methodChannelName);
  final Map<String, Client> _clients = {};

  PublishSubject<MethodCall> _inCalls;
  Observable<MethodCall> calls;

  Observable<EnvelopeChannelMessage> allChannelMessages;
  Observable<EnvelopeChannelStateChange> allChannelStateChanges;

  AblyPlugin() {
    _inCalls = PublishSubject();
    _channel.setMethodCallHandler((MethodCall call) async {
      _inCalls.add(call);
    });

    calls = _inCalls.distinct().doOnData((MethodCall call) {
      print("Method: ${call.method}, Arguments: ${call.arguments}");
    });

    allChannelMessages = calls
        .where(methodIs("Realtime::RealtimeChannel#onMessage"))
        .map(_deserializeMessage);
    allChannelStateChanges = calls
        .where(methodIs("Realtime::RealtimeChannel#onChannelStateChange"))
        .map(_deserializeStateChange);
  }

  void dispose() {
    _inCalls.close();
  }

  Future<void> reassemble() async {
    return await _channel.invokeMethod('reassemble');
  }

  Future<Realtime> newRealtime(String token) async {
    final String clientId = uuid();

    _clients[clientId] = Realtime(
      id: clientId,
      token: token,
      channel: _channel,
      allChannelMessages: allChannelMessages.where(clientIs(clientId)),
      allChannelStateChanges: allChannelStateChanges.where(clientIs(clientId)),
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

  EnvelopeChannelMessage _deserializeMessage(MethodCall call) {
    final args = call.arguments;
    return EnvelopeChannelMessage(
      clientId: args["clientId"],
      channelId: args["channelId"],
      message: ChannelMessage(
        id: args["message"]["id"],
        clientId: args["message"]["clientId"],
        connectionId: args["message"]["connectionId"],
        timestamp: args["message"]["timestamp"],
        encoding: args["message"]["encoding"],
        data: args["message"]["data"],
        name: args["message"]["name"],
      ),
    );
  }

  EnvelopeChannelStateChange _deserializeStateChange(MethodCall call) {
    final args = call.arguments;
    return EnvelopeChannelStateChange(
      clientId: args["clientId"],
      channelId: args["channelId"],
      stateChange: ChannelStateChange(
        current: ChannelState.values[args["stateChange"]["current"]],
        previous: ChannelState.values[args["stateChange"]["previous"]],
        resumed: args["stateChange"]["resumed"],
      ),
    );
  }
}
