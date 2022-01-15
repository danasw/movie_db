import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/src/bloc/moviedetailbloc/movie_detail_bloc.dart';
import 'package:movie_db/src/bloc/moviedetailbloc/movie_detail_event.dart';
import 'package:movie_db/src/bloc/moviedetailbloc/movie_detail_state.dart';
import 'package:movie_db/src/model/movie.dart';
import 'package:movie_db/src/model/movie_detail.dart';
import 'package:movie_db/src/model/movie_screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc()..add(MovieDetailEventStated(movie.id)),
      child: WillPopScope(
          child: Scaffold(
            body: _buildDetailBody(context),
          ),
          onWillPop: () async => true),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return Center(
            child: Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(),
          );
        } else if (state is MovieDetailLoaded) {
          MovieDetail movieDetail = state.detail;
          return Stack(
            children: <Widget>[
              ClipPath(
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/original${movieDetail.backdropPath}',
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () async {
                        final ytUrl =
                            'https://www.youtube.com/embed/${movieDetail.trailerID}';
                        if (await canLaunch(ytUrl)) {
                          await launch(ytUrl);
                        }
                      },
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.play_circle_fill_outlined,
                              color: Colors.yellow,
                              size: 65,
                            ),
                            Text(
                              movieDetail.title!.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Overview',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 180,
                          child: Text(
                            movieDetail.overview!,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Release Date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    movieDetail.releaseDate!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        ?.copyWith(
                                            color: Colors.blue, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Rating',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_half_rounded,
                                          size: 10,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          movieDetail.voteAverage!.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              ?.copyWith(
                                                  color: Colors.blue,
                                                  fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Budget',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      movieDetail.budget!.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              color: Colors.blue, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            // Text(
                            //   'Preview'.toUpperCase(),
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .caption
                            //       ?.copyWith(fontWeight: FontWeight.bold),
                            // ),
                            // Container(
                            //   height: 155,
                            //   child: ListView.separated(
                            //     separatorBuilder: (context, index) =>
                            //         VerticalDivider(
                            //       color: Colors.transparent,
                            //       width: 5,
                            //     ),
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount:
                            //         movieDetail.movieImage?.backdrops.length ??
                            //             0,
                            //     itemBuilder: (context, index) {
                            //       Screenshot image =
                            //           movieDetail.movieImage!.backdrops[index];
                            //       return Container(
                            //         child: Card(
                            //           borderOnForeground: true,
                            //           elevation: 3,
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(12),
                            //           ),
                            //           child: ClipRRect(
                            //             borderRadius: BorderRadius.circular(8),
                            //             child: CachedNetworkImage(
                            //               placeholder: (context, url) => Center(
                            //                 child: Platform.isAndroid
                            //                     ? CircularProgressIndicator()
                            //                     : CupertinoActivityIndicator(),
                            //               ),
                            //               imageUrl:
                            //                   'https://image.tmdb.org/t/p/w500${image.imagePath}',
                            //               fit: BoxFit.cover,
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
