import Flutter
import Ably

typealias AblyErrorCallback = ((ARTErrorInfo?) -> Void)?

enum ChannelError: Error {
  case notFound
}

class ChannelsHandler {
  // MARK: Properties

  var ably: AblyMethodChannel
  var realtime: RealtimeHandler

  // MARK: Constructor

  init(ably: AblyMethodChannel, realtime: RealtimeHandler) {
    self.ably = ably
    self.realtime = realtime
  }

  // MARK: Debug

  func reassemble() {

  }

  // MARK: Init

  func get(_ clientId: String, channelId: String) throws -> ARTRealtimeChannel {
    guard let channel = self.realtime.get(clientId)?.channels.get(channelId) else {
      throw PluginError.notFound(resource: "Realtime::RealtimeChannel#\(channelId)")
    }
    
    return channel
  }

  func setup(_ clientId: String, channelId: String) throws {
    let channel = try self.get(clientId, channelId: channelId)
    // send initial state change
    self.ably.emit("Realtime::RealtimeChannel#onChannelStateChange",
                   arguments: MethodChannelSerializer.envelope(
                    clientId: clientId,
                    channelId: channelId,
                    key: "stateChange",
                    value: MethodChannelSerializer.serializeStateChange(
                      ARTChannelStateChange(
                        current: channel.state,
                        previous: channel.state,
                        event: ARTChannelEvent.initialized,
                        reason: nil
                      )
                    )
      )
    )
    // send future states
    channel.on { (stateChange) in
      if let stateChange = stateChange {
        self.ably.emit("Realtime::RealtimeChannel#onChannelStateChange",
                       arguments: MethodChannelSerializer.envelope(
                        clientId: clientId,
                        channelId: channelId,
                        key: "stateChange",
                        value: MethodChannelSerializer.serializeStateChange(
                          stateChange
                        )
          )
        )
      }
    }
  }

  func dispose(_ clientId: String, channelId: String) throws {
    let channel = try self.get(clientId, channelId: channelId)
    channel.off()
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
      self.ably.emit("Realtime::RealtimeChannel#onMessage",
                     arguments: MethodChannelSerializer.envelope(
                      clientId: clientId,
                      channelId: channelId,
                      key: "message",
                      value: MethodChannelSerializer.serializeMessage(
                        message
                      )
        )
      )
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
}
