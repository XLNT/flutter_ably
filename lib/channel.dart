import './channel_input_message.dart';
import './channel_message.dart';
import './channel_state_change.dart';
import './channel_state.dart';

abstract class Channel {
  String get id;
  Stream<ChannelMessage> get messages;
  Stream<ChannelStateChange> get stateChange;
  Stream<ChannelState> get state;

  Future<void> attach();
  Future<void> detach();
  Future<void> publish(List<ChannelInputMessage> messages);
  Future<void> subscribe(String name);
  Future<void> unsubscribe();
}
