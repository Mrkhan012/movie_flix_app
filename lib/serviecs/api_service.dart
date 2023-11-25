import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_flix_app/model/movie_model.dart';

class MovieService {
  final String apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed";
        // fetch main screen Apis
  Future<List<Results>> fetchNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey"),
    );
    final Map<String, dynamic> data = json.decode(response.body);
    return List<Results>.from(
        data["results"].map((movie) => Results.fromJson(movie)));
  }
    // fetch movie_detail screen Apis
  Future<List<Results>> fetchTopRatedMovies() async {
    final response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey"),
    );
    final Map<String, dynamic> data = json.decode(response.body);
    return List<Results>.from(
        data["results"].map((movie) => Results.fromJson(movie)));
  }
}
