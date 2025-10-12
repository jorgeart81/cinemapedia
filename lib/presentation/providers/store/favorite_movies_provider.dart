import 'package:cinemapedia/domain/common/paginated_result.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/store/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMovieNotifier(storageRepository: localStorageRepository);
});

class StorageMovieNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository storageRepository;
  final int _limit = 10;
  int? _lastId;
  bool _isLastPage = false;

  bool get isLastPage => _isLastPage;

  StorageMovieNotifier({required this.storageRepository}) : super({});

  Future<void> loadNextMovies() async {
    final PaginatedResult<Movie> result = await storageRepository
        .loadFavoriteMovies(limit: _limit, lastId: _lastId);

    final List<Movie> favoriteMovies = result.data;

    final Map<int, Movie> moviesMap = {
      for (final movie in favoriteMovies) movie.id: movie,
    };

    if (_isLastPage) return;
    state = {...state, ...moviesMap};

    _lastId = result.cursor;
    _isLastPage =
        result.pageSize < _limit || result.totalCount - state.keys.length <= 0;
  }

  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await storageRepository.isFavoriteMovie(movie.id);
    await storageRepository.toggleFavoriteMovie(movie);

    if (isFavorite) {
      state.remove(movie.id);
      return;
    }

    state = {...state, movie.id: movie};
  }
}
