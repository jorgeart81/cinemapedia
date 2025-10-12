import 'package:cinemapedia/config/database/database.dart';
import 'package:cinemapedia/domain/common/paginated_result.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:drift/drift.dart';

class DriftDatasource implements LocalStorageDatasource {
  final AppDatabase database;

  DriftDatasource([AppDatabase? databaseToUse])
    : database = databaseToUse ?? db;

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    final query = database.select(database.favoriteMovies)
      ..where((t) => t.movieId.equals(movieId));

    final favoriteMovie = await query.getSingleOrNull();

    return favoriteMovie != null;
  }

  @override
  Future<PaginatedResult<Movie>> loadFavoriteMovies({
    int limit = 10,
    int? lastId,
  }) async {
    final query = database.select(database.favoriteMovies)
      ..orderBy([(t) => OrderingTerm.desc(t.id)]);

    final totalMovies = await query.get();

    if (lastId != null) {
      query.where((t) => t.id.isSmallerThanValue(lastId));
    }

    query.limit(limit);

    final List<FavoriteMovy> movieRows = await query.get();

    return PaginatedResult(
      data: movieRows.map((row) => _favoriteMovyToMovieMapper(row)).toList(),
      cursor: movieRows.isNotEmpty ? movieRows.last.id : null,
      pageSize: movieRows.length,
      totalCount: totalMovies.length,
    );
  }

  Movie _favoriteMovyToMovieMapper(FavoriteMovy row) {
    return Movie(
      adult: false,
      backdropPath: row.backdropPath,
      genreIds: [],
      id: row.movieId,
      originalLanguage: '',
      originalTitle: row.originalTitle,
      overview: '',
      popularity: 0,
      posterPath: row.posterPath,
      releaseDate: DateTime(1900, 1, 1),
      title: row.title,
      video: false,
      voteAverage: row.voteAverage,
      voteCount: 0,
    );
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await isFavoriteMovie(movie.id);

    if (isFavorite) {
      final deleteQuery = database.delete(database.favoriteMovies)
        ..where((t) => t.movieId.equals(movie.id));
      await deleteQuery.go();
      return;
    }

    await _insertMovie(movie);
  }

  Future<void> _insertMovie(Movie movie) async {
    await database
        .into(database.favoriteMovies)
        .insert(
          FavoriteMoviesCompanion.insert(
            movieId: movie.id,
            backdropPath: movie.backdropPath,
            originalTitle: movie.originalTitle,
            posterPath: movie.posterPath,
            title: movie.title,
            voteAverage: Value(movie.voteAverage),
          ),
        );
  }
}
