import Flutter
import Ably

class RealtimeHandler {
  var clients = [String: ARTRealtime]()
  var ably: AblyMethodChannel
  
  init(ably: AblyMethodChannel) {
    self.ably = ably
  }

  func reassemble() {
    // nuke our platform state so that hot reloads are happy
    clients.values.forEach { (client) in
      client.close()
    }
    clients.removeAll()
  }

  func new(token: String) -> String {
    let uuid = UUID().uuidString
    let client = ARTRealtime(token: token)
    clients[uuid] = client
    return uuid
  }

  func dispose(_ clientId: String) {
    clients.removeValue(forKey: clientId)
  }

  func get(_ clientId: String) -> ARTRealtime? {
    return self.clients[clientId]
  }
}
