import 'package:cinemapedia/domain/movie.dart';
import 'package:cinemapedia/infrastructure/models/movie_moviedb.dart';

extension MovieExtensions on MovieMovieDB {
  Movie toEntity() {
    return Movie(
      adult: adult,
      backdropPath: backdropPath != ''
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWcWg0E8pSjBNi0TtiZsqu8uD2PAr_K11DA&s',
      genreIds: genreIds.map((id) => id.toString()).toList(),
      id: id,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath != ''
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : 'no-poster',
      releaseDate: releaseDate,
      title: title,
      video: video,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}
