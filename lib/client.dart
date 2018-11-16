import 'package:flutter/services.dart';
import './channels.dart';

abstract class Client {
  MethodChannel get channel;
  String get id;
  Channels get channels;
}
