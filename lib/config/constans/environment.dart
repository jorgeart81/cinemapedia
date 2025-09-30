import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDBKey =
      dotenv.env['THE_MOVIEDB_KEY'] ??
      (throw Exception('THE_MOVIEDB_KEY no existe'));
  static String theMovieDBURL =
      dotenv.env['THE_MOVIEDB_URL'] ??
      (throw Exception('THE_MOVIEDB_URL no existe'));
}
