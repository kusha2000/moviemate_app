import 'package:flutter/material.dart';
import 'package:moviemate_app/models/movie_model.dart';
import 'package:moviemate_app/services/movies_service.dart';
import 'package:moviemate_app/widgets/movie_details.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Movie> fetchedMovies =
          await _movieService.fetchNowPlayingMovies(page: _currentPage);
      setState(() {
        _movies = fetchedMovies;

        _totalPages = 10;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchMovies();
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Now Playing Movies',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Colors.blue,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildPaginationControls();
                      } else {
                        return MovieDetailsWidget(movie: _movies[index - 1]);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF121826),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Previous button with icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _currentPage > 1 ? _previousPage : null,
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                decoration: BoxDecoration(
                  color: _currentPage > 1
                      ? const Color(0xFF1E4B9A)
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: _currentPage > 1
                            ? Colors.white
                            : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Previous',
                        style: TextStyle(
                          color: _currentPage > 1
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Page indicator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2133),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF2A416A), width: 1),
            ),
            child: Row(
              children: [
                Text(
                  '$_currentPage',
                  style: const TextStyle(
                    color: Color(0xFF4D88FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$_totalPages',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Next button with icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _currentPage < _totalPages ? _nextPage : null,
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                decoration: BoxDecoration(
                  color: _currentPage < _totalPages
                      ? const Color(0xFF1E4B9A)
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          color: _currentPage < _totalPages
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: _currentPage < _totalPages
                            ? Colors.white
                            : Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
