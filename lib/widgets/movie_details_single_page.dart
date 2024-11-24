import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:tmdb_movie_app/models/movie_model.dart';

class MovieDetailsSinglepage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsSinglepage({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsSinglepage> createState() => _MovieDetailsSinglepageState();
}

class _MovieDetailsSinglepageState extends State<MovieDetailsSinglepage> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.movie.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Release Date: ${widget.movie.releaseDate}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.movie.overview,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text(
              //   'Average Vote: ${widget.movie.voteAverage}',
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: Colors.red[600],
              //   ),
              // ),
              Text(
                'Popularity: ${widget.movie.popularity}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Movie Ratings:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                ),
              ),
              RatingStars(
                value: widget.movie.voteAverage / 2,
                onValueChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
                starBuilder: (index, color) => Icon(
                  Icons.star,
                  color: color,
                ),
                starCount: 5,
                starSize: 20,
                valueLabelColor: const Color(0xff9b9b9b),
                valueLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                valueLabelRadius: 10,
                maxValue: 5,
                starSpacing: 2,
                maxValueVisibility: true,
                valueLabelVisibility: true,
                animationDuration: const Duration(milliseconds: 1000),
                valueLabelPadding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                valueLabelMargin: const EdgeInsets.only(right: 8),
                starOffColor: const Color(0xffe7e8ea),
                starColor: Colors.yellow,
              ),
            ],
          )
        ],
      ),
    );
  }
}
