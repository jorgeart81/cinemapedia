import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

typedef ActorsByMovieCallback = Future<List<Actor>> Function(int movieId);

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByNotifier, Map<String, List<Actor>>>((ref) {
      return ActorsByNotifier(
        fetchActorsByMovie: ref.watch(actorRepositoryProvider).getActorsByMovie,
      );
    });

class ActorsByNotifier extends StateNotifier<Map<String, List<Actor>>> {
  ActorsByMovieCallback fetchActorsByMovie;

  ActorsByNotifier({required this.fetchActorsByMovie}) : super({});

  Future<void> loadActorsByMovie(int movieId) async {
    if (state['$movieId'] != null) return;

    final List<Actor> actors = await fetchActorsByMovie(movieId);
    state = {...state, '$movieId': actors};
  }
}
