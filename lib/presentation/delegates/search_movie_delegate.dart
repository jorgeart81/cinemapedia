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
  final List<Movie> initialMovies;
  final void Function() onClear;

  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.initialMovies,
    required this.searchMovies,
    required this.onClear,
  });

  void _clearStreams() {
    debounceMovies.close();
    isLoadingStream.close();
  }

  @override
  String? get searchFieldLabel => 'Buscar película';

  void clearSearch() {
    query = '';
    debounceMovies.add([]);
    // onClear();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          Widget icon = snapshot.data ?? false
              ? SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.clear);

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(onPressed: clearSearch, icon: icon),
          );
        },
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
    return SizedBox.shrink();
  }

  @override
  void showResults(BuildContext context) {
    /// The call to `super` is commented out to disable the rendering of build results.
    // super.showResults(context);
  }

  void _onQueryChange(String seachQuery, [int milliseconds = 500]) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: milliseconds), () async {
      final movies = await searchMovies(seachQuery);
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
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
      initialData: initialMovies,
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
