import Flutter
import Ably

class RealtimeHandler {
  var clients = [String: ARTRealtime]()
  var methodChannel: AblyMethodChannel
  
  init(methodChannel: AblyMethodChannel) {
    self.methodChannel = methodChannel
  }

  func new(_ clientId: String, token: String) throws {
    let options = ARTClientOptions(token: token)
    options.authCallback = { (params: ARTTokenParams, callback: (ARTTokenDetails?, Error?) -> Void) in
      // @TODO - wait for an #authCallback call and then call back to ably
      callback(ARTTokenDetails(token: token), nil)
    }

    let client = ARTRealtime(options: options)
    clients[clientId] = client
  }

  func authorize(_ clientId: String, token: String, callback: @escaping (ARTTokenDetails?, Error?) -> Void) throws {
    self.get(clientId)?.auth.authorize(
      ARTTokenParams(
        options: ARTClientOptions(
          token: token
        )
      ),
                                       options: nil,
                                       callback: callback
    )
  }

  func dispose(_ clientId: String) throws {
    self.clients[clientId]?.close()
    clients.removeValue(forKey: clientId)
  }

  func get(_ clientId: String) -> ARTRealtime? {
    return self.clients[clientId]
  }
}
