import 'package:equatable/equatable.dart';
import 'package:movie_db/src/model/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movieList;
  final List<Movie> trendingList;
  final List<Movie> upcomingList;
  const MovieLoaded(this.movieList, this.trendingList, this.upcomingList);

  @override
  List<Object> get props => [movieList, trendingList, upcomingList];
}

class MovieError extends MovieState {}
