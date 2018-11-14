class ChannelMessage {
  String id;
  String clientId;
  String connectionId;
  String timestamp;
  String encoding;
  String data;
  String name;

  ChannelMessage({
    this.id,
    this.clientId,
    this.connectionId,
    this.timestamp,
    this.encoding,
    this.data,
    this.name,
  });
}
