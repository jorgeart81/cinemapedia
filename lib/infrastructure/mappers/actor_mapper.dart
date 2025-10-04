import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/credits_response.dart';

extension CastExtension on Cast {
  Actor toActorEntity() => Actor(
    id: id,
    name: name,
    profilePath: profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://i.sstatic.net/HQwHI.jpg',
    character: character,
  );
}
