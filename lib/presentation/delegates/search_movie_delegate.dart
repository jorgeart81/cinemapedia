import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef SeachMoviesCallback = Future<List<Movie>> Function(String query);
typedef GoToCallback = void Function(Movie movie);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SeachMoviesCallback searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies});

  void _onQueryChange(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        debounceMovies.add([]);
        return;
      }

      final movies = await searchMovies(query);
      debounceMovies.add(movies);
    });
  }

  void _clearStreams() {
    debounceMovies.close();
  }

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(onPressed: () => query = '', icon: Icon(Icons.clear)),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        _clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('BuildResults');
  }

  void _navigateToMovieScreen(BuildContext context, Movie movie) {
    _clearStreams();
    close(context, movie);
    context.push('/movie/${movie.id}');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);

    return StreamBuilder(
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final List<Movie> movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            goTo: (movie) => _navigateToMovieScreen(context, movie),
          ),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final GoToCallback? goTo;

  const _MovieItem({required this.movie, this.goTo});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (goTo != null) goTo!(movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(movie.posterPath, fit: BoxFit.cover),
              ),
            ),

            SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
                  Text(
                    movie.overview.length > 100
                        ? '${movie.overview.substring(0, 100)}...'
                        : movie.overview,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium?.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
