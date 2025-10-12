class PaginatedResult<T> {
  final List<T> data;
  final int? cursor;
  final int pageSize;
  final int totalCount;

  PaginatedResult({
    required this.data,
    this.cursor,
    required this.pageSize,
    required this.totalCount,
  });
}
