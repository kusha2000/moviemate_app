import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviemate_app/models/movie_model.dart';

class MovieService {
  final String _apiKey = dotenv.env["TMDB_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie/upcoming";
  final String _nowPlayingUrl =
      'https://api.themoviedb.org/3/movie/now_playing';

  //Fetch all upcoming Movies
  Future<List<Movie>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey&page=$page'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error fetching upcoming movies: $error');
      return [];
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse('$_nowPlayingUrl?api_key=$_apiKey&page=$page'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error fetching movies: $error');
      return [];
    }
  }

  //search movies by query
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error fetching movies: $error');
      return [];
    }
  }
}
