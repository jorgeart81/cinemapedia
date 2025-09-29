import 'package:cinemapedia/domain/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int oage = 1});
}
