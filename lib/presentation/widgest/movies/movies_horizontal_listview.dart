import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/movie.dart';
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
            _Title(title: widget.title!, subTitle: widget.subTitle),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _Slide(movie: widget.movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Center(
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    );
                  }

                  return FadeIn(child: child);
                },
              ),
            ),
          ),

          SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: Text(movie.title, maxLines: 2, style: textStyle.titleSmall),
          ),

          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              const SizedBox(width: 3),
              Text(
                movie.voteAverage.toString(),
                style: textStyle.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                HumanFormats.number(movie.popularity),
                style: textStyle.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final String? subTitle;

  const _Title({required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: titleStyle),

          if (subTitle != null)
            FilledButton.tonal(
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}
