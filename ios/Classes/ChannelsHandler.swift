import Flutter
import Ably

typealias AblyErrorCallback = ((ARTErrorInfo?) -> Void)?

enum ChannelError: Error {
  case notFound
}

class ChannelsHandler {
  // MARK: Properties

  var channels = [String: ARTRealtimeChannel]()
  var ably: AblyMethodChannel
  var realtime: RealtimeHandler

  // MARK: Constructor

  init(ably: AblyMethodChannel, realtime: RealtimeHandler) {
    self.ably = ably
    self.realtime = realtime
  }

  // MARK: Debug

  func reassemble() {
    // nuke our platform state so that hot reloads are happy
    channels.values.forEach { (channel) in
      channel.off()
      channel.detach()
    }
    channels.removeAll()
  }

  // MARK: Init

  func get(_ clientId: String, channelId: String) throws -> ARTRealtimeChannel {
    guard let channel = self.realtime.get(clientId)?.channels.get(channelId) else {
      throw ChannelError.notFound
    }
    
    return channel
  }

  func setup(_ clientId: String, channelId: String) throws {
    let channel = try self.get(clientId, channelId: channelId)
    // send initial state change
    self.ably.emit("Realtime::RealtimeChannel#onChannelStateChange", arguments: self.serializeStateChange(
      clientId: clientId,
      channelId: channelId,
      stateChange: ARTChannelStateChange(current: channel.state, previous: channel.state, event: ARTChannelEvent.initialized, reason: nil)
    ))
    // send future states
    channel.on { (stateChange) in
      if let stateChange = stateChange {
        self.ably.emit("Realtime::RealtimeChannel#onChannelStateChange", arguments: self.serializeStateChange(
          clientId: clientId,
          channelId: channelId,
          stateChange: stateChange
        ))
      }
    }
  }

  func dispose(_ clientId: String, channelId: String) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.off()
    channels.removeValue(forKey: channelId)
  }

  // MARK: Lifecycle

  public func attach(_ clientId: String, channelId: String, callback: AblyErrorCallback) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.attach(callback)
  }

  public func publish(_ clientId: String, channelId: String, messages: [Dictionary<String, Any>], callback: AblyErrorCallback) throws {
    let channel = try self.get(clientId, channelId: channelId)
    
    channel.publish(messages.map { (messageData) -> ARTMessage in
      return ARTMessage(name: messageData["name"] as? String, data: messageData["data"]!)
    }, callback: callback)
  }

  public func subscribe(_ clientId: String, channelId: String, name: String?) throws {
    let channel = try self.get(clientId, channelId: channelId)
    let handler = { (message: ARTMessage) in
      self.ably.emit("Realtime::RealtimeChannel#onMessage", arguments: self.serializeMessage(clientId: clientId, channelId: channelId, message: message))
    }

    if let name = name {
      channel.subscribe(name, callback: handler)
    } else {
      channel.subscribe(handler)
    }
  }

  public func unsubscribe(_ clientId: String, channelId: String) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.unsubscribe()
  }

  public func detach(_ clientId: String, channelId: String, callback: AblyErrorCallback) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.detach(callback)
  }

  //  MARK: Presence

  public func enterPresence(_ clientId: String, channelId: String, data: Any?, callback: AblyErrorCallback) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.presence.enter(data, callback: callback)
  }

  public func updatePresence(_ clientId: String, channelId: String, data: Any?, callback: AblyErrorCallback) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.presence.update(data, callback: callback)
  }

  public func leavePresence(_ clientId: String, channelId: String, data: Any?, callback: AblyErrorCallback) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.presence.leave(data, callback: callback)
  }

  // MARK: Internal

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

  private func serializeStateChange(clientId: String, channelId: String, stateChange: ARTChannelStateChange) -> Dictionary<String, Any> {
    return [
      "clientId": clientId,
      "channelId": channelId,
      "stateChange": [
        "current": stateChange.current.rawValue,
        "previous": stateChange.previous.rawValue,
        "resumed": stateChange.resumed,
      ],
    ]
  }
}
