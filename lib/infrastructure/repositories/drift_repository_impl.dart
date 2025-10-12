import 'package:cinemapedia/domain/common/paginated_result.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class DriftRepositoryImpl implements LocalStorageRepository {
  final LocalStorageDatasource datasource;

  DriftRepositoryImpl(this.datasource);

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    return await datasource.isFavoriteMovie(movieId);
  }

  @override
  Future<PaginatedResult<Movie>> loadFavoriteMovies({
    int limit = 10,
    int? lastId,
  }) async {
    return await datasource.loadFavoriteMovies(limit: limit, lastId: lastId);
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    return await datasource.toggleFavoriteMovie(movie);
  }
}
