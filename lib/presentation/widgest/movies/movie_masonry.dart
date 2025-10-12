import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgest/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final Future<void> Function()? loadNextPage;
  final bool isLastPage;

  const MovieMasonry({
    super.key,
    required this.movies,
    this.loadNextPage,
    this.isLastPage = false,
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final loadNextPage = widget.loadNextPage;
    if (loadNextPage == null) return;

    scrollController.addListener(() async {
      if (isLoading || widget.isLastPage) return;

      double pixels = scrollController.position.pixels;
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      bool isAtEnd = pixels + 200 >= maxScrollExtent;

      if (isAtEnd) {
        isLoading = true;
        await loadNextPage();
        isLoading = false;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
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
