class PaginatedResult<T> {
  final List<T> data;
  final int? cursor; // puede ser null si no hay más datos

  PaginatedResult({required this.data, this.cursor});
}
