import './client.dart';
import './realtime_channel.dart';

class Channels {
  Client client;

  Channels({
    this.client,
  });

  Future<RealtimeChannel> get(String id) async {
    await client.channel.invokeMethod("Realtime::RealtimeChannel#get", {
      "clientId": client.id,
      "id": id,
    });

    return RealtimeChannel(
      client: client,
      id: id,
    );
  }
}
