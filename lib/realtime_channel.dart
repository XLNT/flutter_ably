import 'package:rxdart/rxdart.dart';

import './channel.dart';
import './client.dart';

import './channel_input_message.dart';
import './channel_message.dart';
import './channel_state.dart';
import './channel_state_change.dart';

class RealtimeChannel implements Channel {
  final Client client;
  final String id;
  final Observable<ChannelMessage> message;
  final Observable<ChannelStateChange> stateChange;
  final Observable<ChannelState> state;

  RealtimeChannel({
    this.client,
    this.id,
    this.message,
    this.stateChange,
    this.state,
  });

  Future<void> attach() async {
    return await client.channel
        .invokeMethod("Realtime::RealtimeChannel#attach", {
      "clientId": client.id,
      "id": id,
    });
  }

  Future<void> publish(List<ChannelInputMessage> messages) async {
    return await client.channel
        .invokeMethod("Realtime::RealtimeChannel#publish", {
      "clientId": client.id,
      "id": id,
      "messages": _serializeChannelInputMessages(messages),
    });
  }

  Future<void> detach() async {
    return await client.channel
        .invokeMethod("Realtime::RealtimeChannel#detach", {
      "clientId": client.id,
      "id": id,
    });
  }

  Future<void> subscribe(String name) async {
    await client.channel.invokeMethod("Realtime::RealtimeChannel#subscribe", {
      "clientId": client.id,
      "id": id,
      "name": name,
    });
  }

  Future<void> unsubscribe() async {
    await client.channel.invokeMethod("Realtime::RealtimeChannel#unsubscribe", {
      "clientId": client.id,
      "id": id,
    });
  }

  List<Map<String, String>> _serializeChannelInputMessages(
    List<ChannelInputMessage> messages,
  ) {
    return messages
        .map<Map<String, String>>((m) => {
              "name": m.name,
              "data": m.data,
            })
        .toList();
  }
}
