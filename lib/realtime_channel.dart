import './client.dart';
import './channel.dart';
import './channel_input_message.dart';
import './channel_message.dart';
import './channel_state.dart';

class RealtimeChannel implements Channel {
  Client client;
  String id;
  Stream<ChannelState> state;

  RealtimeChannel({
    this.client,
    this.id,
  }) {
    state = client.allChannelStates
        .where((s) => s.channelId == id)
        .map((s) => s.state);
  }

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
      "messages": messages
          .map<Map<String, String>>((m) => {
                "name": m.name,
                "data": m.data,
              })
          .toList(),
    });
  }

  Future<void> close() async {
    return await client.channel
        .invokeMethod("Realtime::RealtimeChannel#close", {
      "clientId": client.id,
      "id": id,
    });
  }

  Future<Stream<ChannelMessage>> subscribe(String name) async {
    await client.channel.invokeMethod("Realtime::RealtimeChannel#subscribe", {
      "clientId": client.id,
      "id": id,
      "name": name,
    });

    return client.allMessages
        .where((message) => message.channelId == id)
        .map((message) => message.message);
  }

  Future<void> unsubscribe() async {
    await client.channel.invokeMethod("Realtime::RealtimeChannel#unsubscribe", {
      "clientId": client.id,
      "id": id,
    });
  }
}
