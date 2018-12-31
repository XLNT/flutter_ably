class RealtimeHistoryQuery {
  DateTime start;
  DateTime end;
  int direction;
  int limit;
  bool untilAttach;

  RealtimeHistoryQuery({
    this.start,
    this.end,
    this.direction,
    this.limit,
    this.untilAttach,
  });
}
