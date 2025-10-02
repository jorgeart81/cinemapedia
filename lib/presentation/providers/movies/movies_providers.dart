import 'package:cinemapedia/domain/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

typedef MovieCallback = Future<List<Movie>> Function({int page});

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchNowPlayingMovies = ref
          .watch(movieRepositoryProvider)
          .getNowPlaying;

      return MoviesNotifier(fetchMoreMovies: fetchNowPlayingMovies);
    });

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchPopularMovies = ref.watch(movieRepositoryProvider).getPopular;

      return MoviesNotifier(fetchMoreMovies: fetchPopularMovies);
    });

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchTopRatedMovies = ref
          .watch(movieRepositoryProvider)
          .getTopRated;

      return MoviesNotifier(fetchMoreMovies: fetchTopRatedMovies);
    });

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchUpcomingMovies = ref.watch(movieRepositoryProvider).getPopular;

      return MoviesNotifier(fetchMoreMovies: fetchUpcomingMovies);
    });

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
