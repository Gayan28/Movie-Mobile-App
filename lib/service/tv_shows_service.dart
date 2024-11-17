import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/tv_show_model.dart';

class TvShowsService {
  // Get the api key from .env variable

  final String _apiKey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";

  Future<List<TVShow>> fetchTVShows() async {
    try {
      // Base url
      final BaseUrl = "https://api.themoviedb.org/3/tv";

      // Popular Tv shows
      final popularResponse =
          await http.get(Uri.parse("$BaseUrl/popular?api_key=$_apiKey"));

      // Airing today Tv shows
      final airingTodayResponse =
          await http.get(Uri.parse("$BaseUrl/airing_today?api_key=$_apiKey"));

      // Top Rated Tv shows
      final topRatedResponse =
          await http.get(Uri.parse("$BaseUrl/top_rated?api_key=$_apiKey"));

      if (popularResponse.statusCode == 200 &&
          airingTodayResponse.statusCode == 200 &&
          topRatedResponse.statusCode == 200) {
        final popularData = json.decode(popularResponse.body);
        final airingTodayData = json.decode(airingTodayResponse.body);
        final topRatedData = json.decode(topRatedResponse.body);

        final List<dynamic> popularResult = popularData["results"];
        final List<dynamic> airingTodayResult = airingTodayData["results"];
        final List<dynamic> topRatedResult = topRatedData["results"];

        List<TVShow> tvShows = [];

        tvShows.addAll(
            popularResult.map((tvData) => TVShow.fromJson(tvData)).take(10));
        tvShows.addAll(airingTodayResult
            .map((tvData) => TVShow.fromJson(tvData))
            .take(10));
        tvShows.addAll(
            topRatedResult.map((tvData) => TVShow.fromJson(tvData)).take(10));

        return tvShows;
      } else {
        throw Exception("Failed to load Tv Shows");
      }

      // Combine the responses into a single list

      // final combinedResponse = (await popularResponse.body)
      //    .jsonDecode()
      //    .cast<Map<String, dynamic>>()
      //    .map((Map<String, dynamic> tvShow) => TVShow.fromMap(tvShow))
      //    .toList()
      //    .concat((await airingTodayResponse.body)
      //        .jsonDecode()
      //        .cast<Map<String, dynamic>>()
      //        .map((Map<String, dynamic> tvShow) => TVShow.fromMap(tvShow))
      //        .toList())
    } catch (error) {
      print("Error fetching TV Shows: $error");
      return [];
    }
  }
}
