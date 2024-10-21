import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/movies_model.dart';

class MoviesService {
  //get the api key from .env
  final String _apiKey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie";

  //Fetch all Upcomming Movies
  Future<List<Movie>> fetchUpcommingMovies({int page = 1}) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "$_baseUrl/upcoming?api_key=$_apiKey&page=$page",
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
      final responce = await http
          .get(Uri.parse("$_baseUrl/now_playing?api_key=$_apiKey&page=$page"));

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

  //Search movie by query
  //https://api.themoviedb.org/3/search/movie?query=ice age&api_key=a8d4032665d01f0c0b9a8a5ab7e61ccc
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final responce = await http.get(
        Uri.parse(
            "https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apiKey"),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Error Searching movies");
      }
    } catch (error) {
      print("Error searchin movie:$error");
      throw Exception("Error searchin movie:$error");
    }
  }

  //Similar Movies
  //https://api.themoviedb.org/3/movie/950/similar?api_key=a8d4032665d01f0c0b9a8a5ab7e61ccc
  Future<List<Movie>> fetchSimilarMovies(int moviedId) async {
    try {
      final responce = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$moviedId/similar?api_key=$_apiKey"));

      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to fetch similar movies");
      }
    } catch (error) {
      print("Faild to fetch similar movies:$error");
      return [];
    }
  }

  //rocomended Movies
  //https://api.themoviedb.org/3/movie/950/recommendations?api_key=a8d4032665d01f0c0b9a8a5ab7e61ccc
  Future<List<Movie>> fetchRecomendedMovies(int moviedId) async {
    try {
      final responce = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$moviedId/recommendations?api_key=$_apiKey"));

      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to fetch recomended movies");
      }
    } catch (error) {
      print("Faild to fetch recomended movies:$error");
      return [];
    }
  }

  //Fetch images by movie ID
  //https://api.themoviedb.org/3/movie/950/images?api_key=a8d4032665d01f0c0b9a8a5ab7e61ccc
  Future<List<String>> fetchImagesFromMovieId(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> backdrops = data['backdrops'];

        // Extract file paths and return the first 10 images
        return backdrops
            .take(10)
            .map((imageData) =>
                'https://image.tmdb.org/t/p/w500${imageData['file_path']}')
            .toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      print('Error fetching images: $error');
      return [];
    }
  }
}
