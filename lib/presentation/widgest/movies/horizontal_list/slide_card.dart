import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/movie.dart';
import 'package:flutter/material.dart';

class SlideCard extends StatelessWidget {
  final Movie movie;

  const SlideCard({super.key, required this.movie});

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
                HumanFormats.number(movie.popularity * 1000),
                style: textStyle.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
