import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/movie_model.dart';

class MovieService {
  // Get the api key from .env variable

  final String _apiKey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie";

  //Fetch all upcoming movies

  Future<List<Movie>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse("$_baseUrl/upcoming?api_key=$_apiKey&page=$page"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Failed to fetch upcoming movies");
      }
    } catch (error) {
      print("Error fetching upcoming movies $error: ");
      return [];
    }
  }
  // Fetch all Now Playing movies

  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse("$_baseUrl/now_playing?api_key=$_apiKey&page=$page"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body); //get data from response body
        final List<dynamic> results = data[
            "results"]; //dynamic data types in list.Because we dont know the types.

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Failed to fetch now playing movies");
      }
    } catch (error) {
      print("Error fetching now playing movies $error: ");
      return [];
    }
  }

  // Search movies by query
  //https://api.themoviedb.org/3/search/movie?query=batman&api_key=c85b6e85f967a23b1be08a8e0ed51b6e

  Future<List<Movie>> searchMovies(String query) async {
    //String query = movie name we are searching
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apiKey"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Failed to search movies");
      }
    } catch (error) {
      print("Error searching movies $error: ");
      throw Exception("$error");
    }
  }

  // Fetch Similar Movies
  //https://api.themoviedb.org/3/movie/299536/similar?api_key=c85b6e85f967a23b1be08a8e0ed51b6e

  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$_apiKey"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      }
      else{
        throw Exception("Failed to fetch similar movies");
      }
    } catch (error) {
      print("Error fetching similar movies $error: ");
      return [];
    }
  }

  // Fetch Recommended movies
  //https://api.themoviedb.org/3/movie/299536/recommendations?api_key=c85b6e85f967a23b1be08a8e0ed51b6e

  Future<List<Movie>> fetchRecommendedMovies(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$_apiKey"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      }
      else {
        throw Exception("Failed to fetch Recommended movies");
      }
    } catch (error) {
      print("Error fetching Recommened movies $error: ");
      return [];
    }
  }

  // Fetch imaages by movie Id
  //https://api.themoviedb.org/3/movie/299536/images?api_key=c85b6e85f967a23b1be08a8e0ed51b6e

  Future<List<String>> fetchImaagesFromMovieId(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> backdrops = data["backdrops"];

        // Extract file paths and return the first 10 images

        return backdrops
            .take(10)
            .map((imageData) =>
                "https://image.tmdb.org/t/p/w500${imageData["file_path"]}")
            .toList();
      }
      else  {
        throw Exception("Failed to fetch images from movieId");
      }
    } catch (error) {
      print("Error fetching images from movieId $error: ");
      return [];
    }
  }
}
