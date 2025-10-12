import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

typedef SeachMoviesByQueryCallback = Future<List<Movie>> Function(String query);

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
      final searchMovies = ref.read(movieRepositoryProvider).searchMovies;

      return SearchMoviesNotifier(fetchSearchMovies: searchMovies, ref: ref);
    });

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SeachMoviesByQueryCallback fetchSearchMovies;
  final Ref ref;

  Map<String, List<Movie>> seachCache = {};

  SearchMoviesNotifier({required this.fetchSearchMovies, required this.ref})
    : super([]);

  Future<List<Movie>> searchMovieByQuery(String query) async {
    final cacheMovies = seachCache[query];

    if (cacheMovies != null && cacheMovies.isNotEmpty) {
      state = cacheMovies;
      return cacheMovies;
    }

    final movies = await fetchSearchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    seachCache = {query: movies};
    state = movies;
    return movies;
  }

  void clearSearch() {
    ref.read(searchQueryProvider.notifier).update((state) => '');
    seachCache = {};
    state = [];
  }
}
