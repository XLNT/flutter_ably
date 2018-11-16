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

  func new(clientId clientId: String, token: String) throws {
    let client = ARTRealtime(token: token)
    clients[clientId] = client
  }

  func dispose(clientId clientId: String) throws {
    clients.removeValue(forKey: clientId)
  }

  func get(_ clientId: String) -> ARTRealtime? {
    return self.clients[clientId]
  }
}
