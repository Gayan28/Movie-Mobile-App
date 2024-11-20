import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/movie_model.dart';
import 'package:tmdb_movie_app/pages/single_movie_details_page.dart';
import 'package:tmdb_movie_app/service/movie_service.dart';
import 'package:tmdb_movie_app/widgets/search_detail.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({super.key});

  @override
  _SearchMoviePageState createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  final TextEditingController _searchController = TextEditingController();
  final MovieService _movieService = MovieService();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  // Method to search for movies
  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      List<Movie> movies =
          await _movieService.searchMovies(_searchController.text);
      setState(() {
        _searchResults = movies;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to find this movie';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for a movie',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _searchMovies(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[600],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                            weight: 10,
                          ),
                          onPressed: _searchMovies,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _searchResults.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchResults = _searchResults.where((results) {
                                return (results.voteAverage / 2) > 4;
                              }).toList();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.amber[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star),
                                Text(
                                  '4.0',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Icon(Icons.arrow_upward_rounded)
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(" Results found: ${_searchResults.length}")
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_error, style: const TextStyle(color: Colors.red)),
              )
            else if (_searchResults.isEmpty)
              const Expanded(
                child: Center(child: Text('No movies found.Please search...')),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleMoviePage(
                              movie: _searchResults[index],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SearchWidget(movie: _searchResults[index]),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
