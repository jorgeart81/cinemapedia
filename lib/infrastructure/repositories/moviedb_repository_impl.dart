import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MoviedbRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MoviedbRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    return await datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    return await datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    return await datasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    return await datasource.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieById(int id) async {
    return await datasource.getMovieById(id);
  }
}
