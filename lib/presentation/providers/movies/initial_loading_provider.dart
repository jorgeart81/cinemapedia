import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  final popularMovies = ref.watch(popularMoviesProvider);
  final topRatedMovies = ref.watch(topRatedMoviesProvider);
  final upcomingMovies = ref.watch(upcomingMoviesProvider);

  bool isLoading =
      nowPlayingMovies.isEmpty ||
      popularMovies.isEmpty ||
      topRatedMovies.isEmpty ||
      upcomingMovies.isEmpty;

  return isLoading;
});
