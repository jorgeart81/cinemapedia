import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/store/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMovieNotifier(storageRepository: localStorageRepository);
});

class StorageMovieNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository storageRepository;

  StorageMovieNotifier({required this.storageRepository}) : super({});

  Future<void> loadFavoriteMovies() async {
    final List<Movie> favoriteMovies = await storageRepository
        .loadFavoriteMovies();

    final Map<int, Movie> moviesMap = {
      for (final movie in favoriteMovies) movie.id: movie,
    };

    state = moviesMap;
  }

  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await storageRepository.isFavoriteMovie(movie.id);
    await storageRepository.toggleFavoriteMovie(movie);

    if (isFavorite) {
      state.remove(movie.id);
      state = {...state};
      return;
    }

    state = {...state, movie.id: movie};
  }
}
