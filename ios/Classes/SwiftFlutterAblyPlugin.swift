import Flutter
import Ably

enum PluginError : Error {
  case invalidArguments(call: FlutterMethodCall)
  case notImplemented
  case notFound(resource: String)
  case invalidState
}

let _kMethodChannelName = "ably"

public class SwiftFlutterAblyPlugin: NSObject, FlutterPlugin {
  var realtime: RealtimeHandler
  var channels: ChannelsHandler
  var history: HistoryHandler

  public init(channel: FlutterMethodChannel) {
    let methodChannel = AblyMethodChannel(channel: channel)
    self.realtime = RealtimeHandler(methodChannel: methodChannel)
    self.channels = ChannelsHandler(methodChannel: methodChannel, realtime: realtime)
    self.history = HistoryHandler(methodChannel: methodChannel, channels: channels)
  }
}

extension SwiftFlutterAblyPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: _kMethodChannelName, binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAblyPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
      try throwableHandle(call, result: result)
    } catch {
      result(self.toFlutterError(error))
    }
  }

  // returning in this function means "I'll handle result async"
  // not returning defaults to result(nil)
  // and throwing throws the error correctly
  private func throwableHandle(_ call: FlutterMethodCall, result: @escaping FlutterResult) throws {
    switch(call.method) {
    case "Realtime#new":
      guard let args = call.arguments as? Dictionary<String, String>,
        let token = args["token"],
        let clientId = args["clientId"]
      else {
        throw PluginError.invalidArguments(call: call)
      }

      try realtime.new(clientId, token: token)
    case "Realtime#authorize":
      guard let args = call.arguments as? Dictionary<String, String>,
        let token = args["token"],
        let clientId = args["clientId"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try realtime.authorize(clientId, token: token) { (tokenDetails: ARTTokenDetails?, error: Error?) in
        if let error = error {
          return result(self.toFlutterError(error))
        }

        return result(nil)
      }
    case "Realtime#dispose":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      try realtime.dispose(clientId)
    case "Realtime::RealtimeChannel#setup":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"]
        else {
          throw PluginError.invalidArguments(call: call)
      }

      try self.channels.setup(clientId, channelId: channelId)
    case "Realtime::RealtimeChannel#dispose":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      try self.channels.dispose(clientId, channelId: channelId)
    case "Realtime::RealtimeChannel#attach":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try self.channels.attach(clientId, channelId: channelId, callback: self.handleErrorWithResult(result))
    case "Realtime::RealtimeChannel#publish":
      guard let args = call.arguments as? Dictionary<String, Any>,
        let clientId = args["clientId"] as? String,
        let channelId = args["id"] as? String,
        let messagesDatas = args["messages"] as? [Dictionary<String, Any>]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try channels.publish(clientId, channelId: channelId, messages: messagesDatas, callback: self.handleErrorWithResult(result))
    case "Realtime::RealtimeChannel#subscribe":
      guard let args = call.arguments as? Dictionary<String, Any>,
        let clientId = args["clientId"] as? String,
        let channelId = args["id"] as? String
      else {
          throw PluginError.invalidArguments(call: call)
      }

      try channels.subscribe(clientId, channelId: channelId, name: args["name"] as? String)
    case "Realtime::RealtimeChannel#unsubscribe":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      try channels.unsubscribe(clientId, channelId: channelId)
    case "Realtime::RealtimeChannel#detach":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try channels.detach(clientId, channelId: channelId, callback: handleErrorWithResult(result))
    case "Realtime::RealtimeChannel#history":
      guard let args = call.arguments as? Dictionary<String, Any>,
        let clientId = args["clientId"] as? String,
        let channelId = args["id"] as? String,
        let query = MethodChannelSerializer.deserializeHistoryQuery(args["query"] as? Dictionary<String, Any>)
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try history.get(clientId: clientId, channelId: channelId, query: query) { (res: ARTPaginatedResult<ARTMessage>?, error: ARTErrorInfo?) -> Void in
        if let error = error {
          return result(self.ablyToFlutterError(error: error))
        }

        guard let res = res else {
          return result(self.toFlutterError(PluginError.invalidState))
        }

        return result(MethodChannelSerializer.serializePaginatedResult(res))
      }
    case "Realtime::RealtimeChannel::Presence#enter":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let data = args["data"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try channels.enterPresence(clientId, channelId: channelId, data: data, callback: self.handleErrorWithResult(result))
    case "Realtime::RealtimeChannel::Presence#leave":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let data = args["data"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try channels.leavePresence(clientId, channelId: channelId, data: data, callback: self.handleErrorWithResult(result))
    case "Realtime::RealtimeChannel::Presence#update":
      guard let args = call.arguments as? Dictionary<String, String>,
        let clientId = args["clientId"],
        let channelId = args["id"],
        let data = args["data"]
      else {
          throw PluginError.invalidArguments(call: call)
      }

      return try channels.updatePresence(clientId, channelId: channelId, data: data, callback: self.handleErrorWithResult(result))
    default:
      throw PluginError.notImplemented
    }

    return result(nil)
  }

  private func handleErrorWithResult(_ result: @escaping FlutterResult) -> (ARTErrorInfo?) -> () {
    return { (error) in
      if let error = error {
        return result(self.ablyToFlutterError(error: error))
      }

      return result(nil)
    }
  }
}

extension SwiftFlutterAblyPlugin {
  private func toFlutterError(_ error: Error) -> Any {
    switch error {
    case PluginError.invalidArguments(let call):
      return invalidArgumentErrorForCall(call)
    case PluginError.notImplemented:
      return FlutterMethodNotImplemented
    default:
      return FlutterError(code: String(describing: error), message: error.localizedDescription, details: nil)
    }
  }

  private func ablyToFlutterError(error: ARTErrorInfo) -> FlutterError {
    return FlutterError(code: String(error.statusCode), message: error.message, details: error.description())
  }

  private func invalidArgumentErrorForCall(_ call: FlutterMethodCall) -> FlutterError {
    return FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments \(String(describing: call.arguments)) provided to method \(call.method).", details: nil)
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
    return Formatter.iso8601.date(from: self)
  }
}
