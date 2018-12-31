import Flutter
import Ably

class RealtimeHandler {
  var clients = [String: ARTRealtime]()
  var methodChannel: AblyMethodChannel
  
  init(methodChannel: AblyMethodChannel) {
    self.methodChannel = methodChannel
  }

  func new(_ clientId: String, token: String) throws {
    let client = ARTRealtime(token: token)
    clients[clientId] = client
  }

  func authorize(_ clientId: String, token: String, callback: @escaping (ARTTokenDetails?, Error?) -> Void) throws {
    self.get(clientId)?.auth.authorize(ARTTokenParams(options: ARTClientOptions(token: token)), options: nil, callback: callback)
  }

  func dispose(_ clientId: String) throws {
    self.clients[clientId]?.close()
    clients.removeValue(forKey: clientId)
  }

  func get(_ clientId: String) -> ARTRealtime? {
    return self.clients[clientId]
  }
}
