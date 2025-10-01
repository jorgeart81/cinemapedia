import 'package:cinemapedia/config/constans/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
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
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBResponse.results
        .where((m) => m.posterPath != 'no-poster')
        .map((m) => m.toEntity())
        .toList();

    return movies;
  }
}
