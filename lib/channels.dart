import './client.dart';
import './realtime_channel.dart';

class Channels {
  Client client;

  Channels({
    this.client,
  });

  RealtimeChannel get(String id) => RealtimeChannel(
        client: client,
        id: id,
      );
}
