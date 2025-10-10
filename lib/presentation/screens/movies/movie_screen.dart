import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  final bool isFavorite = false;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {},
          icon: isFavorite
              ? Icon(Icons.favorite, color: Colors.red)
              : Icon(Icons.favorite_border_outlined),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: SizedBox(
        //   width: double.infinity,
        //   child: Text(
        //     movie.title,
        //     style: TextStyle(fontSize: 20, color: Colors.white70),
        //     textAlign: TextAlign.start,
        //   ),
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: FadeIn(
                child: Image.network(movie.posterPath, fit: BoxFit.cover),
              ),
            ),

            const _CustomGradient(stops: [0.0, 0.3]),

            const _CustomGradient(
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
              stops: [0.0, 0.15],
              colors: [Colors.black12, Colors.transparent],
            ),
            const _CustomGradient(
              begin: AlignmentGeometry.topRight,
              end: AlignmentGeometry.bottomLeft,
              stops: [0.0, 0.15],
              colors: [Colors.black12, Colors.transparent],
            ),

            const _CustomGradient(
              begin: AlignmentGeometry.bottomCenter,
              end: AlignmentGeometry.topCenter,
              stops: [0.0, 0.3],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.topCenter,
    this.end = AlignmentGeometry.bottomCenter,
    required this.stops,
    this.colors = const [Colors.black87, Colors.transparent],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final List<Actor> actors;

  const _MovieDetails({required this.movie, required this.actors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MovieOverview(movie: movie),

          _MovieGenders(movie: movie),

          _ActorsByMovie(actors: actors),
        ],
      ),
    );
  }
}

class _MovieOverview extends StatelessWidget {
  final Movie movie;

  const _MovieOverview({required this.movie});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(movie.posterPath, width: size.width * 0.3),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleLarge),
                  Text(movie.overview),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieGenders extends StatelessWidget {
  final Movie movie;

  const _MovieGenders({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Wrap(
        children: [
          ...movie.genreIds.map(
            (gender) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: Chip(
                label: Text(gender),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorsByMovie extends StatelessWidget {
  final List<Actor> actors;

  const _ActorsByMovie({required this.actors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    height: 180,
                    width: 135,
                    fit: BoxFit.cover,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(actor.name, maxLines: 2),
                      Text(
                        actor.character ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
