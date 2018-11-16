import Flutter

class AblyMethodChannel {
  var channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  func emit(_ method: String, arguments: Any?) {
    self.channel.invokeMethod(method, arguments: arguments)
  }
}
