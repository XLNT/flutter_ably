# Version 1.0

```python
class Rest:
  constructor(keyStr: String) // RSC1
  constructor(tokenStr: String) // RSC1
  constructor(ClientOptions) // RSC1
  auth: Auth // RSC5
  push: Push
  device() => io LocalDevice
  channels: Channels<RestChannel> // RSN1
  request(
    String method,
    String path,
    Dict<String, String> params?,
    JsonObject | JsonArray body?,
    Dict<String, String> headers
  ) => io HttpPaginatedResponse // RSC19
  stats(
    start: Time, // RSC6b1
    end: Time api-default now(), // RSC6b1
    direction: .Backwards | .Forwards api-default .Backwards, // RSC6b2
    limit: int api-default 100, // RSC6b3
    unit: .Minute | .Hour | .Day | .Month api-default .Minute // RSC6b4
  ) => io PaginatedResult<Stats> // RSC6a
  time() => io Time // RSC16
class Realtime:
  constructor(keyStr: String) // RSC1
  constructor(tokenStr: String) // RSC1
  constructor(ClientOptions) // RSC1
  auth: Auth // RTC4
  push: Push
  device() => io LocalDevice
  channels: Channels<RealtimeChannel> // RTC3, RTS1
  clientId: String? // proxy for RSA7
  connection: Connection // RTC2
  request(
    String method,
    String path,
    Dict<String, String> params?,
    JsonObject | JsonArray body?,
    Dict<String, String> headers?
  ) => io HttpPaginatedResponse // RTC9
  stats: // Same as Rest.stats, RTC5a
  close() // proxy for RTN12
  connect() // proxy for RTN11
  time() => io Time // RTC6a
class ClientOptions:
  embeds AuthOptions // TO3j
  autoConnect: Bool default true // RTC1b, TO3e
  clientId: String? // RSC17, RSA4, RSA15, TO3a
  defaultTokenParams: TokenParams? // TO3j11
  echoMessages: Bool default true // RTC1a, TO3h
  environment: String? // RSC15b, TO3k1
  logHandler: // platform specific - TO3c
  logLevel: // platform specific - TO3b
  logExceptionReportingUrl: String default "[library specific]" // TO3c
  port: Int default 80 // TO3k4
  queueMessages: Bool default true // RTP16b, TO3g
  restHost: String default "rest.ably.io" // RSC12, TO3k2
  realtimeHost: String default "realtime.ably.io" // RTC1d, TO3k3
  fallbackHosts: String[] default nil // RSC15b, RSC15a, TO3k6
  recover: String? // RTC1c, TO3i
  tls: Bool default true // RSC18, TO3d
  tlsPort: Int default 443 // TO3k5
  useBinaryProtocol: Bool default true // TO3f
  transportParams: [String: Stringifiable]? // RTC1f
  // configurable retry and failure defaults
  disconnectedRetryTimeout: Duration default 15s // TO3l1
  suspendedRetryTimeout: Duration default 30s // RTN14d, TO3l2
  channelRetryTimeout: Duration default 15s // RTL13b, TO3l7
  httpOpenTimeout: Duration default 4s // TO3l3
  httpRequestTimeout: Duration default 10s // TO3l4
  httpMaxRetryCount: Int default 3 // TO3l5
  httpMaxRetryDuration: Duration default 15s // TO3l6
  maxMessageSize: Int default 65536 // TO3l8
  maxFrameSize: Int default 524288 // TO3l8
class AuthOptions: // RSA8e
  authCallback: ((TokenParams) -> io (String | TokenDetails | TokenRequest | JsonObject))? // RSA4a, RSA4, TO3j5, AO2b
  authHeaders: [String: Stringifiable]? // RSA8c3, TO3j8, AO2e
  authMethod: .GET | .POST default .GET // RSA8c, TO3j7, AO2d
  authParams: [String: Stringifiable]? // RSA8c3, RSA8c1, TO3j9, AO2f
  authUrl: String? // RSA4a, RSA4, RSA8c, TO3j6, AO2c
  key: String? // RSA11, RSA14, TO3j1, AO2a
  queryTime: Bool default false // RSA9d, TO3j10, AO2a
  token: String? | TokenDetails? | TokenRequest? // RSA4a, RSA4, TO3j2
  tokenDetails: TokenDetails? // RSA4a, RSA4, TO3j3
  useTokenAuth: Bool? // RSA4, RSA14, TO3j4
class TokenParams: // RSAA8e
  capability: String api-default '{"*":["*"]}' // RSA9f, TK2b
  clientId: String? // TK2c
  nonce: String? // RSA9c, Tk2d
  timestamp: Time? // RSA9d, Tk2d
  ttl: Duration api-default 60min // RSA9e, TK2a
class Auth:
  clientId: String? // RSA7, RSC17, RSA12
  authorize(TokenParams?, AuthOptions?) => io TokenDetails // RSA10
  createTokenRequest(TokenParams?, AuthOptions?) => io TokenRequest // RSA9
  requestToken(TokenParams?, AuthOptions?) => io TokenDetails // RSA8e
class TokenDetails:
  +fromJson(String | JsonObject) -> TokenDetails// TD7
  capability: String // TD5
  clientId: String? // TD6
  expires: Time // TD3
  issued: Time // TD4
  token: String // TD2
class TokenRequest:
  +fromJson(String | JsonObject) -> TokenRequest // TE6
  capability: String // TE3
  clientId: String? // TE2
  keyName: String // TE2
  mac: String // TE2
  nonce: String // TE2
  timestamp: Time? // TE5
  ttl: Duration? api-default 60min // TE4
class Channels<ChannelType>:
  exists(String) -> Bool // RSN2, RTS2
  get(String) -> ChannelType // RSN3a, RTS3a
  get(String, ChannelOptions) -> ChannelType // RSN3c, RTS3c
  iterate() -> Iterator<ChannelType> // RSN2, RTS2
  release(String) // RSN4, RTS4
class RestChannel:
  name: String?
  presence: RestPresence // RSL3
  history(
    start: Time, // RSL2b1
    end: Time api-default now(), // RSL2b1
    direction: .Backwards | .Forwards api-default .Backwards, // RSL2b2
    limit: int api-default 100 // RSL2b3
  ) => io PaginatedResult<Message> // RSL2a
  publish([Message]) => io // RSL1
  publish(name: String?, data: Data?, clientId?: String, extras?: JsonObject) => io // RSL1, RSL1h
  // Only on platforms that support receiving notifications:
  push: PushChannel // RSH4
class RealtimeChannel:
  embeds EventEmitter<ChannelEvent, ChannelStateChange?> // RTL2a, RTL2d, RTL2e
  errorReason: ErrorInfo? // RTL4e
  state: ChannelState // RTL2b
  presence: RealtimePresence // RTL9
  properties: ChannelProperties // CP1, RTL15
  push: PushChannel
  attach() => io // RTL4d
  detach() => io // RTL5e
  history(
    start: Time, // RTL10a
    end: Time api-default now(), // RTL10a
    direction: .Backwards | .Forwards api-default .Backwards, // RTL10a
    limit: int api-default 100, // RTL10a
    untilAttach: Bool default false // RTL10b
  ) => io PaginatedResult<Message> // RSL2a
  publish([Message]) => io // RTL6i
  publish(name: String?, data: Data?, clientId?: String, extras?: JsonObject) => io // RTL6i, RTL6h
  subscribe((Message) ->) => io // RTL7a
  subscribe(String, (Message) ->) => io // RTL7b
  unsubscribe() // RTL8a, RTE5
  unsubscribe((Message) ->) // RTL8a
  unsubscribe(String, (Message) ->) // RTL8a
class PushChannel:
  subscribeDevice() => io // RSH4a
  subscribeClientId() => io // RSH4b
  unsubscribeDevice() => io // RSH4c
  unsubscribeClientId() => io // RSH4d
  listSubscriptions() => io PaginatedResult<PushChannelSubscription> // RSH4e
enum ChannelState:
  INITIALIZED
  ATTACHING
  ATTACHED
  DETACHING
  DETACHED
  SUSPENDED
  FAILED
enum ChannelEvent:
  embeds ChannelState
  UPDATE // RTL2g
class ChannelStateChange:
  current: ChannelState // RTL2a, RTL2b
  event: ChannelEvent // TH5
  previous: ChannelState // RTL2a, RTL2b
  reason: ErrorInfo? // RTL2e, TH3
  resumed: Boolean // RTL2f, TH4
class ChannelOptions:
  +withCipherKey(key: Binary | String)? -> ChannelOptions // TB3
  cipher: (CipherParams | Params)? // RSL5a, TB2b
class CipherParams:
  algorithm: String default "AES" // TZ2a
  key: Binary // TZ2d
  keyLength: Int // TZ2b
  mode: String default "CBC" // TZ2c
class Crypto:
  +getDefaultParams(Params) -> CipherParams // RSE1
  +generateRandomKey(keyLength: Int?) => io Binary // RSE2
class RestPresence:
  get(
    limit: int api-default 100, // RSP3a
    clientId: String?, // RSP3a2
    connectionId: String?, // RSP3a3
  ) => io PaginatedResult<PresenceMessage> // RSPa
  history(
    start: Time, // RSP4b1
    end: Time api-default now(), // RSP4b1
    direction: .Backwards | .Forwards api-default .Backwards, // RSP4b2
    limit: int api-default 100, // RSP4b3
  ) => io PaginatedResult<PresenceMessage> // RSP4a
class RealtimePresence:
  syncComplete: Bool // RTP13
  get(
    waitForSync: Bool default true, // RTP11c1
    clientId: String?, // RTP11c2
    connectionId: String?, // RTP11c3
  ) => io [PresenceMessage] // RTP11
  history(
    start: Time, // RTP12a
    end: Time, // RTP12a
    direction: .Backwards | .Forwards api-default .Backwards, // RTP12a
    limit: int api-default 100, // RTP12a
    untilAttach: Bool default false // RTP12b
  ) => io PaginatedResult<PresenceMessage> // RTP12c
  subscribe((PresenceMessage) ->) => io // RTP6a
  subscribe(PresenceAction, (PresenceMessage) ->) => io // RTP6b
  unsubscribe() // RTP7a, RTE5
  unsubscribe((PresenceMessage) ->) // RTP7a
  unsubscribe(PresenceAction, (PresenceMessage) ->) // RTP7b
  // presence state modifiers
  enter(Data?, extras?: JsonObject) => io // RTP8
  update(Data?, extras?: JsonObject) => io // RTP9
  leave(Data?, extras?: JsonObject) => io // RTP10
  enterClient(clientId: String, Data?, extras?: JsonObject) => io // RTP4, RTP14, RTP15
  updateClient(clientId: String, Data?, extras?: JsonObject) => io // RTP15
  leaveClient(clientId: String, Data?, extras?: JsonObject) => io // RTP15
enum PresenceAction:
  ABSENT // TP2
  PRESENT // TP2
  ENTER // TP2
  LEAVE // TP2
  UPDATE // TP2
class ConnectionDetails:
  clientId: String? // RSA12a, CD2a
  connectionKey: String // RTN15e, CD2b
  connectionStateTtl: Duration // CD2f, RTN14e, DF1a
  maxFrameSize: Int // CD2d
  maxInboundRate: Int // CD2e
  maxMessageSize: Int // CD2c
  serverId: String // CD2g
  maxIdleInterval: Duration // CD2h
class Message:
  constructor(name: String?, data: Data?) // TM2
  constructor(name: String?, data: Data?, clientId: String?) // TM2
  +fromEncoded(JsonObject, ChannelOptions?) -> Message // TM3
  +fromEncodedArray(JsonArray, ChannelOptions?) -> [Message] // TM3
  clientId: String? // RSL1g1, TM2b
  connectionId: String? // TM2c
  data: Data? // TM2d
  encoding: String? // TM2e
  extras: JsonObject? // TM2i
  id: String // TM2a
  name: String? // TM2g
  timestamp: Time // TM2f
class PresenceMessage
  +fromEncoded(JsonObject, ChannelOptions?) -> PresenceMessage // TP4
  +fromEncodedArray(JsonArray, ChannelOptions?) -> [PresenceMessage] // TP4
  action: PresenceAction // TP3b
  clientId: String // TP3c
  connectionId: String // TP3d
  data: Data? // TP3e
  encoding: String? // TP3f
  extras: JsonObject? // TP3i
  id: String // TP3a
  timestamp: Time // TP3g
  memberKey() -> String // TP3h
class ProtocolMessage:
  action: ProtocolMessageAction // TR2, TR4a
  auth: AuthDetails? //
  channel: String? // TR4b
  channelSerial: String? // TR4c
  connectionDetails: ConnectionDetails? // RSA7b3, RTN19, TR4o
  connectionId: String? // RTN15c1, TR4d
  connectionSerial: Int? // RTN10c, TR4f
  count: Int? // TR4g
  error: ErrorInfo? // RTN15c2, TR4h
  flags: .HAS_PRESENCE & .HAS_BACKLOG & .RESUMED ? // RTP1, TR3, TR4i, RTL2f
  id: String? // TR4b
  messages: [Message]? // TR4k
  msgSerial: Int? // RTN7b, TR4j
  presence: [PresenceMessage]? // TR4l
  timestamp: Time? // TR4m
enum ProtocolMessageAction:
  HEARTBEAT // TR2
  ACK // TR2
  NACK // TR2
  CONNECT // TR2
  CONNECTED // TR2
  DISCONNECT // TR2
  DISCONNECTED // TR2
  CLOSE // TR2
  CLOSED // TR2
  ERROR // TR2
  ATTACH // TR2
  ATTACHED // TR2
  DETACH // TR2
  DETACHED // TR2
  PRESENCE // TR2
  MESSAGE // TR2
  SYNC // TR2
  AUTH // TR2
class AuthDetails: // RTC8
  accessToken: String // AD2
class Connection:
  embeds EventEmitter<ConnectionEvent, ConnectionStateChange> // RTN4a, RTN4e, RTN4g
  errorReason: ErrorInfo? // RTN14a
  id: String? // RTN8
  key: String? // RTN9
  recoveryKey: String? // RTN16b, RTN16c
  serial: Int // RTN10
  state: ConnectionState // RTN4d
  close() // RTN12
  connect() // RTC1b, RTN3, RTN11
  ping() => io // RTN13
enum ConnectionState:
  INITIALIZED
  CONNECTING
  CONNECTED
  DISCONNECTED
  SUSPENDED
  CLOSING
  CLOSED
  FAILED
enum ConnectionEvent:
  embeds ConnectionState
  UPDATE // RTN4h
class ConnectionStateChange:
  current: ConnectionState // TA2
  event: ConnectionEvent // TA5
  previous: ConnectionState // TA2
  reason: ErrorInfo? // RTN4f, TA3
  retryIn: Duration? // RTN14d, TA2
class Stats:
  intervalId: String // TS12a
  intervalTime: Time // TS12b (calculated clientside)
  unit: Stats.IntervalGranularity // TS12c
  intervalGranularity: Stats.IntervalGranularity? // TS12d (deprecated)
  all: Stats.MessageTypes // TS12e
  inbound: Stats.MessageTraffic // TS12f
  outbound: Stats.MessageTraffic // TS12g
  persisted: Stats.MessageTypes // TS12h
  connections: Stats.ConnectionTypes // TS12i
  channels: Stats.ResourceCount // TS12j
  apiRequests: Stats.RequestCount // TS12k
  tokenRequests: Stats.RequestCount // TS12l
  push: Stats.PushStats // TS12m
  xchgProducer: Stats.XchgMessages // TS12n
  xchgConsumer: Stats.XchgMessages // TS12o
enum StatsIntervalGranularity:
  MINUTE
  HOUR
  DAY
  MONTH
class DeviceDetails:
  id: String
  clientId: String?
  formFactor: DeviceFormFactor
  metadata: JsonObject
  platform: DevicePlatform
  push: DevicePushDetails
  deviceSecret: String?
class DevicePushDetails:
  errorReason: ErrorInfo?
  recipient: JsonObject
  state: .Active | .Failing | .Failed
class LocalDevice extends DeviceDetails:
  deviceIdentityToken: String
class Push:
  admin: PushAdmin // RSH1
  // Only on platforms that support receiving notifications:
  activate(
    registerCallback: ((ErrorInfo?, DeviceDetails?) -> io String)?,
    // Only on platforms that, after first set, can update later its push
    // device details:
    updateFailedCallback: ((ErrorInfo) ->)
  ) => io ErrorInfo? // RSH2a
  deactivate(
    deregisterCallback: ((ErrorInfo?, deviceId: String?) -> io)?
  ) => io ErrorInfo? // RSH2b
class PushAdmin:
  publish(recipient: JsonObject, data: JsonObject) => io // RSH1a
  deviceRegistrations: PushDeviceRegistrations // RSH1b
  channelSubscriptions: PushChannelSubscriptions // RSH1c
class JsonObject:
  // Platform-dependent, typically a Dict-like object
class PushDeviceRegistrations:
  get(DeviceDetails) => io DeviceDetails // RSH1b1
  get(deviceId: String) => io DeviceDetails // RSH1b1
  list(params: Dict<String, String>) => io PaginatedResult<DeviceDetails> // RSH1b2
  save(DeviceDetails) => io DeviceDetails // RSH1b3
  remove(DeviceDetails) => io // RSH1b4
  remove(deviceId: String) => io // RSH1b4
  removeWhere(params: Dict<String, String>) => io // RSH1b5
class PushChannelSubscriptions:
  list(params: Dict<String, String>) => io PaginatedResult<PushChannelSubscription> // RSH1c1
  listChannels(params: Dict<String, String>?) => io PaginatedResult<String> // RSH1c2
  save(PushChannelSubscription) => io PushChannelSubscription // RSH1c3
  remove(PushChannelSubscription) => io // RSH1c4
  removeWhere(params: Dict<String, String>) => io // RSH1c5
enum DevicePushTransportType:
  "fcm" // PTT1
  "gcm" // PTT1
  "apns" // PTT1
  "web" // PTT1
enum DevicePlatform:
  "android" // PPT1
  "ios" // PPT1
  "browser" // PPT1
enum DeviceFormFactor:
  "phone" // PDT1
  "tablet" // PDT1
  "desktop" // PDT1
  "tv" // PDT1
  "watch" // PDT1
  "car" // PDT1
  "embedded" // PDT1
  "other" // PDT1
class PushChannelSubscription:
  +forDevice(channel: String, deviceId: String) => PushChannelSubscription
  +forClientId(channel: String, clientId: String) => PushChannelSubscription
  deviceId: String? // PCS2, PCS5, PCS6
  clientId: String? // PCS3, PCS6
  channel: String // PCS4
class ErrorInfo:
  code: Int // TI1
  href: String? // TI4
  message: String // TI1
  cause: ErrorInfo? // TI1
  statusCode: Int // TI1
class EventEmitter<Event, Data>:
  on((Data...) ->) // RTE4
  on(Event, (Data...) ->) // RTE4
  once((Data...) ->) // RTE4
  once(Event, (Data...) ->) // RTE4
  off() // RTE5
  off((Data...) ->) // RTE5
  off(Event, (Data...) ->) // RTE5
  emit(Event, Data...)  // RTE6
class PaginatedResult<T>:
  items: [T] // TG3
  first() => io PaginatedResult<T> // TG5
  hasNext() -> Bool // TG6
  isLast() -> Bool // TG7
  next() => io PaginatedResult<T>? // TG4
class HttpPaginatedResponse // RSC19b
  embeds PaginatedResult<JsonObject>
  items: [JsonObject] // HP3
  statusCode: Int // HP4
  success: Bool // HP5
  errorCode: Int // HP6
  errorMessage: String // HP7
  headers: Dict<String, String> // HP8
```
