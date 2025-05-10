import 'package:flutter/material.dart';
import 'package:moviemate_app/models/movie_model.dart';

class MovieDetailsSinglePage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsSinglePage({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF1A1A2E), // Darker blue background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Hero poster with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[850],
                    child: const Icon(Icons.broken_image,
                        size: 80, color: Colors.white60),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        movie.releaseDate.split('-')[0], // Just the year
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Title with accent bar
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Release date with icon
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.blue[300]),
              const SizedBox(width: 8),
              Text(
                'Release Date: ${movie.releaseDate}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue[300],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Overview section
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[200],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  const Color(0xFF16213E), // Slightly lighter blue for contrast
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
            ),
            child: Text(
              movie.overview,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Stats row with styled containers
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3460), // Deep blue
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.thumbs_up_down, color: Colors.blue[300]),
                      const SizedBox(height: 6),
                      Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[200],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${movie.voteAverage.toStringAsFixed(2)}/10',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3460), // Deep blue
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, color: Colors.blue[300]),
                      const SizedBox(height: 6),
                      Text(
                        'Popularity',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[200],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.popularity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
