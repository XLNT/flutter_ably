import Ably

extension ARTPaginatedResult {
  @objc func getNext() -> NSMutableURLRequest? {
    return self.value(forKey: "_relNext") as? NSMutableURLRequest
  }
}

class MethodChannelSerializer {
  static func envelope(clientId: String, channelId: String, key: String, value: Any) -> Dictionary<String, Any> {
    return [
      "clientId": clientId,
      "channelId": channelId,
      key: value,
    ]
  }

  static func deserializeHistoryQuery(_ query: Dictionary<String, Any>?) -> ARTRealtimeHistoryQuery? {
    guard let query = query
      else {
        return nil
    }

    let start = query["start"] as? Double
    let end = query["end"] as? Double
    let direction = query["direction"] as? UInt
    let limit = query["limit"] as? UInt16
    let untilAttach = query["untilAttack"] as? Bool

    let q = ARTRealtimeHistoryQuery()
    if let start = start {
      q.start = Date(timeIntervalSince1970: start)
    }

    if let end = end {
      q.end = Date(timeIntervalSince1970: end)
    }

    if let direction = direction, let dir = ARTQueryDirection(rawValue: direction) {
      q.direction = dir
    }

    if let limit = limit {
      q.limit = limit
    }

    if let untilAttach = untilAttach {
      q.untilAttach = untilAttach
    }

    return q
  }

  static func serializePaginatedResult(_ result: ARTPaginatedResult<ARTMessage>) -> Dictionary<String, Any?> {
    return [
      "hasNext": result.hasNext,
      "items": result.items.map(serializeMessage),
      "nextQuery": result.getNext()?.url
    ]
  }


  static func serializeMessage(_ message: ARTMessage) -> Dictionary<String, Any?> {
    return [
      "id": message.id,
      "clientId": message.clientId,
      "connectionId": message.connectionId,
      "timestamp": message.timestamp == nil ? nil : Formatter.iso8601.string(from: message.timestamp!),
      "encoding": message.encoding,
      "data": message.data,
      "name": message.name
    ]
  }

  static func serializeStateChange(_ stateChange: ARTChannelStateChange) -> Dictionary<String, Any> {
    return [
      "current": stateChange.current.rawValue,
      "previous": stateChange.previous.rawValue,
      "resumed": stateChange.resumed,
    ]
  }
}
