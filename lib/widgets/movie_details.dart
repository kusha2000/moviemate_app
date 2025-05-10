import 'package:flutter/material.dart';
import 'package:moviemate_app/models/movie_model.dart';
import 'package:moviemate_app/pages/single_movie.dart';

class MovieDetailsWidget extends StatefulWidget {
  final Movie movie;

  const MovieDetailsWidget({
    super.key,
    required this.movie,
  });

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleMoviePage(movie: widget.movie),
          ),
        );
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1A1A2E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Movie Poster
                Stack(
                  children: [
                    Hero(
                      tag: 'movie_${widget.movie.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              color: const Color(0xFF1C2526),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFF2E63),
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: const Color(0xFF1C2526),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Color(0xFF4A4A4A),
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF0A0A0A).withOpacity(0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Title
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Text(
                        widget.movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black87,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Details Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Release Date
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Color(0xFFFF2E63),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Release: ${widget.movie.releaseDate}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFD1D1D1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Overview
                      const Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.movie.overview,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFFA0A0A0),
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      // Ratings and Popularity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Color(0xFFFFD700),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Rating: ${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFD1D1D1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 18,
                                color: Color(0xFF00E676),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Popularity: ${widget.movie.popularity.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFD1D1D1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
