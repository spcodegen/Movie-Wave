import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/tv_show_model.dart';

class TvShowsService {
  //api key
  final String _apikey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";

  Future<List<TvShow>> fetchTVShows() async {
    try {
      //base url
      const String BaseUrl = "https://api.themoviedb.org/3/tv";
      //popular tv shows
      final popularResponce =
          await http.get(Uri.parse("$BaseUrl/popular?api_key=$_apikey"));

      //airing today tv shows
      final airingTodayResponce =
          await http.get(Uri.parse("$BaseUrl/airing_today?api_key=$_apikey"));

      //top rated tv shows
      final topRatedResponce =
          await http.get(Uri.parse("$BaseUrl/top_rated?api_key=$_apikey"));

      if (popularResponce.statusCode == 200 &&
          airingTodayResponce.statusCode == 200 &&
          topRatedResponce.statusCode == 200) {
        final popularData = json.decode(popularResponce.body);
        final airingData = json.decode(airingTodayResponce.body);
        final topRatedData = json.decode(topRatedResponce.body);

        final List<dynamic> popularResult = popularData["results"];
        final List<dynamic> airingResult = airingData["results"];
        final List<dynamic> topRatedResult = topRatedData["results"];

        List<TvShow> tvShows = [];

        tvShows.addAll(
            popularResult.map((tvData) => TvShow.fromJson(tvData)).take(10));
        tvShows.addAll(
            airingResult.map((tvData) => TvShow.fromJson(tvData)).take(10));
        tvShows.addAll(
            topRatedResult.map((tvData) => TvShow.fromJson(tvData)).take(10));

        return tvShows;
      } else {
        throw Exception("Faild to load Tv Shows");
      }
    } catch (error) {
      print("Error fetching tv shows:$error");
      return [];
    }
  }
}
