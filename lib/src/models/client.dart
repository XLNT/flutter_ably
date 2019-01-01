import 'package:flutter/services.dart';
import './channels.dart';

abstract class Client {
  String get id;
  MethodChannel get channel;
  Channels get channels;

  Future<void> setup(String token);
  Future<void> dispose();
}
