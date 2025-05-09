import 'package:flutter/material.dart';
import 'package:moviemate_app/models/tv_show_model.dart';
import 'package:moviemate_app/services/tv_show_service.dart';
import 'package:moviemate_app/widgets/tv_show_details.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  final TvShowService _tvShowService = TvShowService();
  List<TVShow> _tvShows = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchTVShows();
  }

  Future<void> _fetchTVShows() async {
    try {
      List<TVShow> tvShows = await _tvShowService.fetchTVShows();
      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load TV shows: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child:
                      Text(_error, style: const TextStyle(color: Colors.red)),
                )
              : ListView.builder(
                  itemCount: _tvShows.length,
                  itemBuilder: (context, index) {
                    return TVShowListItem(tvShow: _tvShows[index]);
                  },
                ),
    );
  }
}
