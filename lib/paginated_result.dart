class PaginatedResult<T> {
  bool hasNext;
  List<T> items;

  PaginatedResult({
    this.hasNext,
    this.items,
  });
}
