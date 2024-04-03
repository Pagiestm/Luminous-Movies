import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Accueil extends StatelessWidget {
  const Accueil({Key? key}) : super(key: key);

  static const List<String> imageUrls = [
    'https://image.tmdb.org/t/p/w500/xD9mc8JCVXA8T8u4Od7qOUBuGH4.jpg',
    'https://image.tmdb.org/t/p/w500/6KErczPBROQty7QoIsaa6wJYXZi.jpg',
    'https://image.tmdb.org/t/p/w500/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg',
    'https://image.tmdb.org/t/p/w500/7D430eqZj8y3oVkLFfsWXGRcpEG.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Text(
            'Les dernières sorties',
            style: TextStyle(
                fontFamily: 'Sora', fontSize: 24, color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 400, // Définit la hauteur du slider d'images
          child: PageView.builder(
            controller: PageController(
                viewportFraction:
                    0.8), // Affiche une petite partie des images suivantes
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        16.0), // Ajoute des marges à gauche et à droite de chaque image
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Arrondit les bords de l'image
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Text(
            'Votre liste',
            style: TextStyle(
                fontFamily: 'Sora', fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
