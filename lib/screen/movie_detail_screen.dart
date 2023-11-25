import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Results movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.yellow.shade800,
      appBar: AppBar(
        title: const Text("Back"),
        backgroundColor: Colors.yellow.shade800,
      ), 
      // Use of the stack is to expand the size of image To fit in the screen
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://image.tmdb.org/t/p/original${movie.backdropPath}",
            placeholder: (context, url) => SizedBox(
              height: height * 0.4,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Card(
                  color: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Title: ${movie.title ?? ""}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Release Date: ${movie.releaseDate ?? ""}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Popularity: ${movie.popularity ?? ""}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          " Overview: ${movie.overview ?? ""}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
