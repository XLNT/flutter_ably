import 'dart:async';
import 'package:flutter/services.dart';

import './client_channel_state.dart';
import './channel_state.dart';
import './client_message.dart';
import './channel_message.dart';
import './client.dart';
import './realtime.dart';

const String methodChannelName = 'ably';

class Ably {
  static const MethodChannel _channel = const MethodChannel(methodChannelName);
  static Map<String, Client> clients = {};

  static void initialize() {
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        print("Method: ${call.method}, Arguments: ${call.arguments}");
        switch (call.method) {
          case "Realtime::RealtimeChannel#onMessage":
            final message = _deserializeMessage(call.arguments);
            clients[message.clientId].onMessage(message);
            break;
          case "Realtime::RealtimeChannel#onChannelState":
            final state = _deserializeState(call.arguments);
            clients[state.clientId].onChannelState(state);
            break;
          default:
            print("Unknown method ${call.method} with args ${call.arguments}");
        }
      } catch (e) {
        print("method call handler error: ${e.toString()}");
        rethrow;
      }
    });
  }

  static Future<String> doTheThing(String text) async {
    return await _channel.invokeMethod('test', {'text': text});
  }

  static Future<Realtime> newRealtime(String token) async {
    final String clientId =
        await _channel.invokeMethod('Realtime#new', {'token': token});

    clients[clientId] = Realtime(id: clientId, channel: _channel);

    return clients[clientId];
  }

  static ClientMessage _deserializeMessage(args) {
    return ClientMessage(
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

  static ClientChannelState _deserializeState(args) {
    return ClientChannelState(
      clientId: args["clientId"],
      channelId: args["channelId"],
      state: ChannelState.values[args["state"]],
    );
  }
}
