import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgest/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

typedef _LoadNextPageCallback = Future<List<Movie>> Function();

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final _LoadNextPageCallback? loadNextPage;

  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          return index == 1
              ? Column(
                  children: [
                    SizedBox(height: 20),
                    MoviePosterLink(movie: widget.movies[index]),
                  ],
                )
              : MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
