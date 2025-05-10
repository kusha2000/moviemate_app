import 'package:flutter/material.dart';
import 'package:moviemate_app/models/movie_model.dart';
import 'package:moviemate_app/services/movies_service.dart';
import 'package:moviemate_app/widgets/movie_details_single_page.dart';

// ignore: must_be_immutable
class SingleMoviePage extends StatefulWidget {
  Movie movie;

  SingleMoviePage({super.key, required this.movie});

  @override
  State<SingleMoviePage> createState() => _SingleMoviePageState();
}

class _SingleMoviePageState extends State<SingleMoviePage> {
  final MovieService _movieService = MovieService();
  List<Movie> _similarMovies = [];
  List<Movie> _recommendedMovies = [];
  List<String> _movieImages = [];
  bool _isLoadingSimilar = true;
  bool _isLoadingRecommended = true;
  bool _isLoadingImages = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchSimilarMovies();
    _fetchRecommendedMovies();
    _fetchMovieImages();
  }

  Future<void> _fetchSimilarMovies() async {
    try {
      List<Movie> fetchedMovies =
          await _movieService.fetchSimilarMovies(widget.movie.id);
      setState(() {
        _similarMovies = fetchedMovies;
        _isLoadingSimilar = false;
      });
    } catch (e) {
      print('Error fetching similar movies: $e');
      setState(() {
        _isLoadingSimilar = false;
      });
    }
  }

  Future<void> _fetchRecommendedMovies() async {
    try {
      List<Movie> fetchedMovies =
          await _movieService.fetchRecommendedMovies(widget.movie.id);
      setState(() {
        _recommendedMovies = fetchedMovies;
        _isLoadingRecommended = false;
      });
    } catch (e) {
      print('Error fetching recommended movies: $e');
      setState(() {
        _isLoadingRecommended = false;
      });
    }
  }

  Future<void> _fetchMovieImages() async {
    try {
      List<String> fetchedImages =
          await _movieService.fetchImagesFromMovieId(widget.movie.id);
      setState(() {
        _movieImages = fetchedImages;
        _isLoadingImages = false;
      });
    } catch (e) {
      print('Error fetching movie images: $e');
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  void _selectMovie(Movie selectedMovie) {
    setState(() {
      widget.movie = selectedMovie;
      _isLoadingSimilar = true;
      _isLoadingRecommended = true;
      _isLoadingImages = true;
    });

    // Reset scroll position
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // Fetch new data
    _fetchMovieImages();
    _fetchSimilarMovies();
    _fetchRecommendedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0A0C17), // Very dark blue/black background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0C17),
              Color(0xFF0E121B),
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // Space for AppBar
                MovieDetailsSinglePage(movie: widget.movie),

                const SizedBox(height: 30),
                _buildSectionHeader('Movie Gallery', Icons.photo_library),
                _buildImageSection(),

                if (_similarMovies.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  _buildSectionHeader('Similar Movies', Icons.movie_filter),
                  _buildMovieSection(_similarMovies, _isLoadingSimilar),
                ],

                if (_recommendedMovies.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  _buildSectionHeader('Recommended For You', Icons.recommend),
                  _buildMovieSection(_recommendedMovies, _isLoadingRecommended),
                ],

                const SizedBox(height: 30), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[400], size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (_isLoadingImages) {
      return _buildLoadingIndicator();
    }

    if (_movieImages.isEmpty) {
      return _buildEmptyState('No images available for this movie');
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _movieImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _movieImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 280,
                  color: Colors.grey[850],
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        size: 40, color: Colors.white60),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection(List<Movie> movies, bool isLoading) {
    if (isLoading) {
      return _buildLoadingIndicator();
    }

    if (movies.isEmpty) {
      return _buildEmptyState('No movies found');
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _selectMovie(movies[index]),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF192841),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster image
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                          height: 180,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 180,
                            width: 140,
                            color: Colors.grey[850],
                            child: const Icon(Icons.broken_image,
                                color: Colors.white60),
                          ),
                        ),
                        // Rating badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  movies[index].voteAverage.toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Title and info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movies[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF192841),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie, size: 48, color: Colors.blue[200]),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.blue[100],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
