import 'package:cinemapedia/domain/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
