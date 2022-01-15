import 'package:bloc/bloc.dart';
import 'package:movie_db/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:movie_db/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:movie_db/src/model/movie.dart';
import 'package:movie_db/src/service/api_service.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is MovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    List<Movie> movieList = [];
    List<Movie> trendingList = [];
    List<Movie> upcomingList = [];
    yield MovieLoading();
    try {
      if (movieId == 0) {
        movieList = await service.getNowPlayingMovie();
        trendingList = await service.getTrendingMovie();
        upcomingList = await service.getUpcomingMovie();
      } else {
        trendingList = await service.getTrendingMovie();
        upcomingList = await service.getUpcomingMovie();
      }
      yield MovieLoaded(movieList, trendingList, upcomingList);
    } on Exception catch (e) {
      print(e);
      yield MovieError();
    }
  }
}
