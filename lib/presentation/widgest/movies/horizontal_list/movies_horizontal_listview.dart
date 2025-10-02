import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/movie.dart';
import 'package:cinemapedia/presentation/widgest/movies/horizontal_list/list_header.dart';
import 'package:cinemapedia/presentation/widgest/movies/horizontal_list/slide_card.dart';
import 'package:flutter/material.dart';

class MoviesHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MoviesHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage,
  });

  @override
  State<MoviesHorizontalListview> createState() =>
      _MoviesHorizontalListviewState();
}

class _MoviesHorizontalListviewState extends State<MoviesHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      double pixels = scrollController.position.pixels;
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      bool isAtEnd = pixels + 200 >= maxScrollExtent;

      if (isAtEnd) {
        widget.loadNextPage!();
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
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            ListHeader(title: widget.title!, subTitle: widget.subTitle),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(
                  child: SlideCard(movie: widget.movies[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
