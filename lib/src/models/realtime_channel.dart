import 'package:rxdart/rxdart.dart';

import './channel.dart';
import './client.dart';

import './paginated_result.dart';
import './realtime_history_query.dart';
import './message.dart';
import './channel_state.dart';
import './channel_state_change.dart';

class RealtimeChannel implements Channel {
  final Client client;
  final String id;
  final Observable<Message> messages;
  final Observable<ChannelStateChange> stateChange;
  final Observable<ChannelState> state;

  RealtimeChannel({
    this.client,
    this.id,
    this.messages,
    this.stateChange,
    this.state,
  });

  Future<void> setup() async {
    return _call("setup");
  }

  Future<void> dispose() async {
    return _call("dispose");
  }

  Future<void> attach() async {
    return _call("attach");
  }

  Future<void> detach() async {
    return _call("detach");
  }

  Future<void> subscribe(String name) async {
    return _call("subscribe", {"name": name});
  }

  Future<void> unsubscribe() async {
    return _call("unsubscribe");
  }

  Future<PaginatedResult<Message>> history(RealtimeHistoryQuery query) async {
    final res = await _call("history", {
      "query": query.toJson(),
    });

    return PaginatedResult<Message>.fromJson(Map.from(res));
  }

  Future<void> publish(List<Message> messages) async {
    return _call("publish", {
      "messages": messages.map((m) => m.toJson()).toList(),
    });
  }

  Future<dynamic> _call(
    String methodName, [
    Map<String, dynamic> args = const {},
  ]) async {
    final Map<String, dynamic> baseArgs = {
      "clientId": client.id,
      "id": id,
    };

    return client.channel.invokeMethod(
      "Realtime::RealtimeChannel#$methodName",
      baseArgs..addAll(args),
    );
  }
}
