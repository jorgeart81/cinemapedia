import 'package:cinemapedia/domain/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int oage = 1});
}
