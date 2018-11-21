import Ably

typealias HistoryCallback = (ARTPaginatedResult<ARTMessage>?, ARTErrorInfo?)  -> Void

class HistoryHandler {
  var ably: AblyMethodChannel
  var channels: ChannelsHandler

  init(ably: AblyMethodChannel, channels: ChannelsHandler) {
    self.ably = ably
    self.channels = channels
  }

  func get(clientId: String, channelId: String, query: ARTRealtimeHistoryQuery, callback: @escaping HistoryCallback) throws {
    try channels.get(clientId, channelId: channelId).history(query, callback: callback)
  }
}
