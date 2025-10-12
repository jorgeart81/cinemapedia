import 'package:cinemapedia/domain/common/paginated_result.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);
  Future<PaginatedResult<Movie>> loadFavoriteMovies({
    int limit = 10,
    int? lastId,
  });
}
