import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_db/src/model/movie.dart';
import 'package:movie_db/src/model/movie_detail.dart';
import 'package:movie_db/src/model/movie_image.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'api_key=[API KEY HERE]';

  Future<List<Movie>> getNowPlayingMovie() async {
    try {
      print('Call now playing');
      final url = '$baseUrl/movie/now_playing?$apiKey&language=en-US&page=1';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('error: $error stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getTrendingMovie() async {
    try {
      print('Call now playing');
      final url = '$baseUrl/movie/popular?$apiKey&language=en-US&page=1';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('error: $error stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getUpcomingMovie() async {
    try {
      final url = '$baseUrl/movie/upcoming?$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('error: $error stacktrace: $stacktrace');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      print('movie detail api called');
      var response =
          await _dio.get('$baseUrl/movie/$movieId?$apiKey&language=en-US');
      var responseBody = response.data;

      MovieDetail movieDetail = MovieDetail.fromJson(responseBody);
      // final Map parsed = jsonDecode(response);

      // MovieDetail movieDetail = MovieDetail.fromJson(response);
      movieDetail.trailerID = await getYoutubeId(movieId);
      // movieDetail.trailerID = await getYoutubeId(movieId);

      // movieDetail.movieImage = await getMovieImage(movieId);

      // movieDetail.castList = await getCastList(movieId);

      return movieDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$id/videos?$apiKey');
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId/images?$apiKey');
      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // Future<List<Cast>> getCastList(int movieId) async {
  //   try {
  //     final response =
  //         await _dio.get('$baseUrl/movie/$movieId/credits?$apiKey');
  //     var list = response.data['cast'] as List;
  //     List<Cast> castList = list
  //         .map((c) => Cast(
  //             name: c['name'],
  //             profilePath: c['profile_path'],
  //             character: c['character']))
  //         .toList();
  //     return castList;
  //   } catch (error, stacktrace) {
  //     throw Exception(
  //         'Exception accoured: $error with stacktrace: $stacktrace');
  //   }
  // }
}
