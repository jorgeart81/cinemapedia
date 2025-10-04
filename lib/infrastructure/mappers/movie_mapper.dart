import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/movie_moviedb.dart';

extension MovieDBExtension on MovieMovieDB {
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
          : 'https://www.legrand.es/modules/custom/legrand_ecat/assets/img/no-image.png',
      releaseDate: releaseDate != null ? releaseDate! : DateTime(1900, 1, 1),
      title: title,
      video: video,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}

extension MovieDetailsExtension on MovieDetails {
  Movie toEntity() {
    return Movie(
      adult: adult,
      backdropPath: (backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      genreIds: genres.map((e) => e.name).toList(),
      id: id,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: (posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
      releaseDate: releaseDate,
      title: title,
      video: video,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}
