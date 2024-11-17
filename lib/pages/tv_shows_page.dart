import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/tv_show_model.dart';
import 'package:tmdb_movie_app/service/tv_shows_service.dart';
import 'package:tmdb_movie_app/widgets/tv_show_widget.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<TVShow> _tvShows = [];
  bool _isLoading = true;
  String _error = "";

  // Fetch Tv shows
  Future<void> _fetchTvShows() async {
    try {
      List<TVShow> tvShows = await TvShowsService().fetchTVShows();
      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (error) {
      print("Error $error");
      setState(() {
        _error = "Error fetching TV shows";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TV Shows'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _error.isNotEmpty
                ? Center(
                    child: Text(_error),
                  )
                : ListView.builder(
                    itemCount: _tvShows.length,
                    itemBuilder: (context, index) {
                      return TVShowWidget(tvShow: _tvShows[index]);
                    },
                  ));
  }
}
