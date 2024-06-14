import 'package:flutter/material.dart';

class ClubCardImage extends StatelessWidget {
  const ClubCardImage({
    super.key,
    required this.bannerImageURL,
  });

  final String bannerImageURL;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: bannerImageURL,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          bannerImageURL,
          height: 72,
        ),
      ),
    );
  }
}
