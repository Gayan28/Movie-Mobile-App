import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/movie_model.dart';
import 'package:tmdb_movie_app/pages/single_movie_details_page.dart';
import 'package:tmdb_movie_app/service/movie_service.dart';
import 'package:tmdb_movie_app/widgets/movie_detail.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  // This method fetches the upcoming movies from the Api and this method is called in the initState method.

  Future<void> _fetchMovies() async {
    // use void because we don't want to return
    if (_isLoading || !_hasMore) {
      //hasMore is false it returns nothing
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(
        seconds:
            1)); // if someone scrolling many requests going to _currentPage for that we can use a delay
    try {
      final newMovies =
          await MovieService().fetchUpcomingMovies(page: _currentPage);
      print(newMovies.length);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie',
          style: TextStyle(
              fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            // check if we scroll to the last
            _fetchMovies();
          }
          return true;
        },
        child: ListView.builder(
            itemCount: _movies.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _movies.length) {
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
              final Movie movie = _movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SingleMoviePage(movie: movie)
                              )
                              );
                },
                child: MovieDetailWidget(
                  movie: movie,
                ),
              );
            }),
      ),
    );
  }
}
