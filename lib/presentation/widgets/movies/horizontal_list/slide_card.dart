import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef GoToCallback = void Function(int id);

class SlideCard extends StatelessWidget {
  final Movie movie;
  final GoToCallback goTo;

  const SlideCard({super.key, required this.movie, required this.goTo});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      final double size = 25;

                      return Container(
                        color: Colors.white70,
                        child: Center(
                          child: SizedBox(
                            height: size,
                            width: size,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () {
                        goTo(movie.id);
                      },
                      child: FadeIn(child: child),
                    );
                  },
                ),
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

          Spacer(flex: 1),
        ],
      ),
    );
  }
}
