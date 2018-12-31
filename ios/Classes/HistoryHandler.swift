import Ably

typealias HistoryCallback = (ARTPaginatedResult<ARTMessage>?, ARTErrorInfo?)  -> Void

class HistoryHandler {
  var methodChannel: AblyMethodChannel
  var channels: ChannelsHandler

  init(methodChannel: AblyMethodChannel, channels: ChannelsHandler) {
    self.methodChannel = methodChannel
    self.channels = channels
  }

  func get(clientId: String, channelId: String, query: ARTRealtimeHistoryQuery, callback: @escaping HistoryCallback) throws {
    try channels.get(clientId, channelId: channelId).history(query, callback: callback)
  }
}
