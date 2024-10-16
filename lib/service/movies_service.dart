import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/movies_model.dart';

class MoviesService {
  //get the api key from .env
  final String _apiKey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie/upcoming";
  final String _baseUrlNew = "https://api.themoviedb.org/3/movie/now_playing";

  //Fetch all Upcomming Movies
  Future<List<Movie>> fetchUpcommingMovies({int page = 1}) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "$_baseUrl?api_key=$_apiKey&page=$page",
        ),
      );

      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to load the data");
      }
    } catch (error) {
      print("Error fetching upcoming movies $error");
      return [];
    }
  }

  //fetch all now playing movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final responce =
          await http.get(Uri.parse("$_baseUrlNew?api_key=$_apiKey&page=$page"));

      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to load the data");
      }
    } catch (error) {
      print("Error fetching now playing movies $error");
      return [];
    }
  }
}
