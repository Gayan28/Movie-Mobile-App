import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/movie_model.dart';
import 'package:tmdb_movie_app/service/movie_service.dart';
import 'package:tmdb_movie_app/widgets/movie_detail.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  List<Movie> _movies = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  //Methods to fetch the movies

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Movie> fetchMovies =
          await MovieService().fetchNowPlayingMovies(page: _currentPage);

      setState(() {
        _movies = fetchMovies;
        _totalPages = 100;
      });
    } catch (error) {
      print('Failed to fetch movies: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //go to previous page
  void previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchMovies();
    }
  }

  //go to next page
  void nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
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
          title: const Text('Now Playing'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: _movies.length + 1,
                          itemBuilder: (context, index) {
                            if (index > _movies.length - 1) {
                              return _buildPaginationControls();
                            } else {
                              return MovieDetailWidget(movie: _movies[index]);
                            }
                          }))
                ],
              ));
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 1 ? previousPage : null,
          child: const Text('Previous'),
        ),
        const SizedBox(
          width: 8,
        ),
        Text('Page $_currentPage of $_totalPages'),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: _currentPage < _totalPages ? nextPage : null,
          child: const Text('Next'),
        ),
      ],
    );
  }
}
