import 'package:equatable/equatable.dart';

import 'movie_screenshot.dart';

class MovieImage extends Equatable {
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  const MovieImage({required this.backdrops, required this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result) {
    return MovieImage(
      backdrops: (result['backdrops'] as List)
              ?.map((b) => Screenshot.fromJson(b))
              ?.toList() ??
          List.empty(),
      posters: (result['posters'] as List)
              ?.map((b) => Screenshot.fromJson(b))
              ?.toList() ??
          List.empty(),
    );
  }

  @override
  List<Object> get props => [backdrops, posters];
}
