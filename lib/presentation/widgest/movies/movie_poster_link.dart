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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: src,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: downloadProgress.progress,
            ),
          ),
          cacheManager: CacheManager(
            Config(
              'favoriesKey',
              stalePeriod: const Duration(days: 7),
              maxNrOfCacheObjects: 20,
            ),
          ),
        ),
      ),
    );
  }
}
