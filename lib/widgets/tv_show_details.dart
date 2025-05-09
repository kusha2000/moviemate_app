import 'package:flutter/material.dart';
import 'package:moviemate_app/models/tv_show_model.dart';

class TVShowListItem extends StatelessWidget {
  final TVShow tvShow;

  const TVShowListItem({super.key, required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C), // Dark background
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: 320, // Explicit height for the container
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.expand, // Ensures Stack fills its parent
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [
                    0.4,
                    0.8
                  ], // Clear from top to 40%, blur from 40% to 80%
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Clear image (visible at the top)
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E1E2C),
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.white54, size: 50),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF1E1E2C),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating and Year row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '${tvShow.voteAverage}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            tvShow.firstAirDate.substring(0, 4),
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 3),

                    // Show title
                    Text(
                      tvShow.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8.0),

                    // Overview text
                    Text(
                      tvShow.overview,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
