import 'package:cinemapedia/domain/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  bool _isLoading = false;
  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (_isLoading) return;

    _isLoading = true;
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(Duration(microseconds: 200));
    _isLoading = false;
  }
}
