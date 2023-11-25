import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_flix_app/model/movie_model.dart';
import 'package:movie_flix_app/screen/movie_detail_screen.dart';

class MovieCell extends StatelessWidget {
  final Results movie;

  const MovieCell({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MediaQuery fro Responsive design
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
            // use for Row of show image and titile , overview 
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/w342${movie.posterPath}",
                width: width * 0.3,
                height: height * 0.2,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? "",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: height * 0.0),
                    Text(
                      movie.overview ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // this divider is use for line between the moviecell 
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}


