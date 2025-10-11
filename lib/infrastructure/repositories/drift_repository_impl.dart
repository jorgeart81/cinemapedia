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
  Future<List<Movie>> loadFavoriteMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    return await datasource.loadFavoriteMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    return await datasource.toggleFavoriteMovie(movie);
  }
}
