import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/moviebloc/movie_bloc.dart';
import '../bloc/moviebloc/movie_bloc_event.dart';
import '../bloc/moviebloc/movie_bloc_state.dart';
import '../model/movie.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(0, '')),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.menu,
            color: Colors.blue,
          ),
          title: Text(
            'home'.toUpperCase(),
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 15),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/popcorn.png'),
                ),
              ),
            )
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //NOW PLAYING
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Now Playing',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
                if (state is MovieLoading) {
                  return Center(
                    child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                  );
                } else if (state is MovieLoaded) {
                  //SHOW NOW PLAYING
                  List<Movie> movies = state.movieList;
                  print(movies.length);
                  return Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: movies.length,
                        itemBuilder:
                            (BuildContext context, int index, int pageIndex) {
                          Movie movie = movies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailScreen(movie: movie)));
                            },
                            child: Stack(
                              // alignment: Alignment.bottomLeft,
                              children: <Widget>[
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Platform.isAndroid
                                            ? CircularProgressIndicator()
                                            : CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Text('Error: $error'),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15, left: 15),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Rating: ${movie.voteAverage}',
                                          style: TextStyle(
                                              fontSize: 8, color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(microseconds: 900),
                            pauseAutoPlayOnTouch: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
              //END OF NOW PLAYING
              SizedBox(
                height: 10,
              ),
              //TRENDING
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Trending',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return Center();
                  } else if (state is MovieLoaded) {
                    List<Movie> movieList = state.trendingList;
                    return Container(
                      padding: EdgeInsets.all(15),
                      height: 225,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            Movie movie = movieList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailScreen(movie: movie)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: 120,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => Container(
                                        width: 120,
                                        height: 160,
                                        child: Center(
                                          child: Platform.isAndroid
                                              ? CircularProgressIndicator()
                                              : CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Text('something wrong $error'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 120,
                                    child: Text(
                                      movie.title.toUpperCase(),
                                      style: TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          movie.voteAverage,
                                          style: TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => VerticalDivider(
                                color: Colors.transparent,
                                width: 5,
                              ),
                          scrollDirection: Axis.horizontal,
                          itemCount: movieList.length),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              //END OF TRENDING
              //UPCOMING
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return Center();
                  } else if (state is MovieLoaded) {
                    List<Movie> movieList = state.upcomingList;
                    return Container(
                      padding: EdgeInsets.all(15),
                      height: 225,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            Movie movie = movieList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailScreen(movie: movie)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: 120,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => Container(
                                        width: 120,
                                        height: 160,
                                        child: Center(
                                          child: Platform.isAndroid
                                              ? CircularProgressIndicator()
                                              : CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Text('something wrong $error'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 120,
                                    child: Text(
                                      movie.title.toUpperCase(),
                                      style: TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          movie.voteAverage,
                                          style: TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => VerticalDivider(
                                color: Colors.transparent,
                                width: 5,
                              ),
                          scrollDirection: Axis.horizontal,
                          itemCount: movieList.length),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
