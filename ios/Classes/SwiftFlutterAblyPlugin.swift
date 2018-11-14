import Flutter
import UIKit
import Ably

let _kMethodChannelName = "ably";

public class SwiftFlutterAblyPlugin: NSObject, FlutterPlugin {
  var clients = [String: ARTRealtime]()
  var channel: FlutterMethodChannel
  public init(channel: FlutterMethodChannel) {
    self.channel = channel
  }
}

extension SwiftFlutterAblyPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: _kMethodChannelName, binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAblyPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch(call.method) {
    case "Realtime#new":
      guard let args = call.arguments as? Dictionary<String, String>,
        let token = args["token"]
      else {
          return result(invalidArgumentErrorForCall(call))
      }
      let uuid = UUID().uuidString
      let client = ARTRealtime(token: token)

      clients[uuid] = client;

      result(uuid)
    case "Realtime::RealtimeChannel#get":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let channel = self.getChannel(clientId: clientId, channelId: channelId)
      else {
        return result(self.invalidArgumentErrorForCall(call))
      }

      channel.on { (stateChange) in
        if let state = stateChange?.current {
          self.channel.invokeMethod("Realtime::RealtimeChannel#onChannelState", arguments: self.serializeState(clientId: clientId, channelId: channelId, state: state))
        }
      }

      return result(nil)
    case "Realtime::RealtimeChannel#attach":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let channel = self.getChannel(clientId: clientId, channelId: channelId)
      else {
        return result(self.invalidArgumentErrorForCall(call))
      }

      channel.attach { (error) in
        if let error = error {
          return result(self.toFlutterError(error: error))
        }

        return result(nil)
      }
    case "Realtime::RealtimeChannel#publish":
      guard let args = call.arguments as? Dictionary<String, Any>,
        let clientId = args["clientId"] as? String,
        let channelId = args["id"] as? String,
        let channel = self.getChannel(clientId: clientId, channelId: channelId),
        let messagesDatas = args["messages"] as? [Dictionary<String, Any>]
      else {
        return result(self.invalidArgumentErrorForCall(call))
      }
      let messages = messagesDatas.map { (messageData) -> ARTMessage in
        return ARTMessage(name: messageData["name"] as? String, data: messageData["data"]!)
      }

      channel.publish(messages) { (error) in
        if let error = error {
          return result(self.toFlutterError(error: error))
        }
        return result(nil)
      }
    case "Realtime::RealtimeChannel#subscribe":
      guard let args = call.arguments as? Dictionary<String, Any>,
        let clientId = args["clientId"] as? String,
        let channelId = args["id"] as? String,
        let channel = self.getChannel(clientId: clientId, channelId: channelId)
      else {
        return result(self.invalidArgumentErrorForCall(call))
      }

      let handler = { (message: ARTMessage) in
        self.channel.invokeMethod("Realtime::RealtimeChannel#onMessage", arguments: self.serializeMessage(clientId: clientId, channelId: channelId, message: message))
      }

      if let name = args["name"] as? String {
        channel.subscribe(name, callback: handler)
      } else {
        channel.subscribe(handler)
      }

      return result(nil)
    case "Realtime::RealtimeChannel#unsubscribe":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let channel = self.getChannel(clientId: clientId, channelId: channelId)
      else {
        return result(self.invalidArgumentErrorForCall(call))
      }
      channel.unsubscribe()
      result(nil)

    case "Realtime::RealtimeChannel#detach":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let channel = self.getChannel(clientId: clientId, channelId: channelId)
      else {
          return result(self.invalidArgumentErrorForCall(call))
      }
      channel.detach { (error) in
        if let error = error {
          return result(self.toFlutterError(error: error))
        }

        return result(nil)
      }
    default:
      return result(FlutterMethodNotImplemented)
    }
  }
}

extension SwiftFlutterAblyPlugin {
  private func getChannel(clientId: String, channelId: String) -> ARTRealtimeChannel? {
    return clients[clientId]?.channels.get(channelId);
  }

  private func toFlutterError(error: ARTErrorInfo) -> FlutterError {
    return FlutterError(code: String(error.statusCode), message: error.message, details: error.description())
  }

  private func invalidArgumentErrorForCall(_ call: FlutterMethodCall) -> FlutterError {
    return FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments \(String(describing: call.arguments)) provided to method \(call.method).", details: nil)
  }

  private func serializeMessage(clientId: String, channelId: String, message: ARTMessage) -> Dictionary<String, Any> {
    return [
      "clientId": clientId,
      "channelId": channelId,
      "message": [
        "id": message.id,
        "clientId": message.clientId,
        "connectionId": message.connectionId,
        "timestamp": message.timestamp == nil ? nil : Formatter.iso8601.string(from: message.timestamp!),
        "encoding": message.encoding,
        "data": message.data,
        "name": message.name
      ]
    ]
  }

  private func serializeState(clientId: String, channelId: String, state: ARTRealtimeChannelState) -> Dictionary<String, Any> {
    return [
      "clientId": clientId,
      "channelId": channelId,
      "state": state.rawValue,
    ]
  }
}

extension Formatter {
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
  }()
}
extension Date {
  var iso8601: String {
    return Formatter.iso8601.string(from: self)
  }
}

extension String {
  var dateFromISO8601: Date? {
    return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
  }
}
