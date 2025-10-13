import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/store/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgest/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Status { loading, success }

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  Status status = Status.loading;

  Future<void> _loadData() async {
    await ref.read(favoriteMoviesProvider.notifier).loadNextMovies();
    setState(() {
      status = Status.success;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Movie> favoriteMoviesMap = ref.watch(favoriteMoviesProvider);
    final List<Movie> favoriteMovies = favoriteMoviesMap.values.toList();

    return Scaffold(
      body: switch (status) {
        Status.loading => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        Status.success =>
          favoriteMovies.isNotEmpty
              ? MovieMasonry(
                  movies: favoriteMovies,
                  isLastPage: ref
                      .read(favoriteMoviesProvider.notifier)
                      .isLastPage,
                  loadNextPage: ref
                      .read(favoriteMoviesProvider.notifier)
                      .loadNextMovies,
                )
              : _EmptyMovies(),
      },
    );
  }
}

class _EmptyMovies extends StatelessWidget {
  const _EmptyMovies();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_outlined,
            size: 50,
            color: colorScheme.primary,
          ),
          SizedBox(height: 8),
          Text('No tienes películas favoritas'),
        ],
      ),
    );
  }
}
