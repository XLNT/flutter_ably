import './channel_state.dart';
import './channel_input_message.dart';
import './channel_message.dart';

abstract class Channel {
  String get id;
  Stream<ChannelState> get state;

  Future<void> attach();
  Future<void> detach();
  Future<void> publish(List<ChannelInputMessage> messages);
  Future<Stream<ChannelMessage>> subscribe(String name);
  Future<void> unsubscribe();
}
