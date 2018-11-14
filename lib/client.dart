import 'package:flutter/services.dart';

import './client_channel_state.dart';
import './client_message.dart';
import './channels.dart';

abstract class Client {
  String id;
  MethodChannel channel;
  Channels channels;
  Stream<ClientMessage> get allMessages;
  Stream<ClientChannelState> get allChannelStates;

  void onMessage(ClientMessage message);
  void onChannelState(ClientChannelState state);
}
