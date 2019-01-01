import './message.dart';
import './channel_state_change.dart';
import './channel_state.dart';

abstract class Channel {
  String get id;
  Stream<Message> get messages;
  Stream<ChannelStateChange> get stateChange;
  Stream<ChannelState> get state;

  Future<void> attach();
  Future<void> detach();
  Future<void> publish(List<Message> messages);
  Future<void> subscribe(String name);
  Future<void> unsubscribe();
}
