import 'package:cinemapedia/config/constans/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource implements ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.theMovieDBURL,
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(int movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    if (response.statusCode != 200) {
      throw Exception('Movie with id: $movieId not found');
    }

    final creditsResponse = CreditsResponse.fromJson(response.data);

    return creditsResponse.cast.map((cast) => cast.toActorEntity()).toList();
  }
}
