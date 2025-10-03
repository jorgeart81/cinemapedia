import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/credits_response.dart';

extension CastExtension on Cast {
  Actor toActorEntity() => Actor(
    id: id,
    name: name,
    profilePath: profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://upload.wikimedia.org/wikipedia/commons/2/25/Profile_photo_placeholder_-_jagged_edges.svg',
    character: character,
  );
}
