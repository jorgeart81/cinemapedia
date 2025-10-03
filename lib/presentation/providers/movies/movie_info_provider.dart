import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

typedef GetMovieCallback = Future<Movie> Function(int id);

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
      final getMovieById = ref.watch(movieRepositoryProvider).getMovieById;

      return MovieMapNotifier(getMovie: getMovieById);
    });

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(int id) async {
    if (state[id.toString()] != null) return;

    Movie movie = await getMovie(id);
    state = {...state, '$id': movie};
  }
}
