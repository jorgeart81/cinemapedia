import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/store/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/store/is_favorite_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'movie_screen_details.dart';
part 'movie_screen_sliver.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.movieId == 'no-id') return;
    final int? movieId = int.tryParse(widget.movieId);
    if (movieId == null) return;

    ref.read(movieInfoProvider.notifier).loadMovie(movieId);
    ref.read(actorsByMovieProvider.notifier).loadActorsByMovie(movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final List<Actor>? actors = ref.watch(
      actorsByMovieProvider,
    )[widget.movieId];

    if (movie == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _MovieDetails(movie: movie, actors: actors ?? []),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
