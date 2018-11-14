import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

import './client.dart';
import './client_message.dart';
import './client_channel_state.dart';
import './channels.dart';

class Realtime implements Client {
  // public
  String id;
  MethodChannel channel;
  Channels channels;
  Stream<ClientMessage> get allMessages => _allMessages;
  Stream<ClientChannelState> get allChannelStates => _allChannelStates;

  // private
  PublishSubject<ClientMessage> _allMessages;
  PublishSubject<ClientChannelState> _allChannelStates;

  Realtime({
    this.id,
    this.channel,
  }) {
    _allMessages = PublishSubject();
    _allChannelStates = PublishSubject();
    channels = Channels(
      client: this,
    );
  }

  void onMessage(ClientMessage message) {
    _allMessages.add(message);
  }

  void onChannelState(ClientChannelState state) {
    _allChannelStates.add(state);
  }

  dispose() {
    _allMessages.close();
    _allChannelStates.close();
  }
}
