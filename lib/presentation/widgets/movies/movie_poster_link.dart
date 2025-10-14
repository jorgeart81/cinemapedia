import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;

  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: _Poster(src: movie.posterPath),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.src});

  final String src;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              src,
              cacheManager: CacheManager(
                Config(
                  'favoriesKey',
                  stalePeriod: const Duration(days: 7),
                  maxNrOfCacheObjects: 20,
                ),
              ),
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
