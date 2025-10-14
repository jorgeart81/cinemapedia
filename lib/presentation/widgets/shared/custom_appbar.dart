import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    final searchMovies = ref.read(searchedMoviesProvider);
    final searchMovieNotifier = ref
        .read(searchedMoviesProvider.notifier)
        .searchMovieByQuery;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.movie_outlined, color: colors.primary),
                  const SizedBox(width: 5),
                  Text('Cinemapedia', style: titleStyle),
                ],
              ),

              IconButton(
                onPressed: () {
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchMovies,
                      searchMovies: (query) => searchMovieNotifier(query),
                      onClear: ref
                          .read(searchedMoviesProvider.notifier)
                          .clearSearch,
                    ),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
