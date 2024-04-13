import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.image, required this.name});

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OctoImage(
            image: NetworkImage(image),
            width: double.infinity,
            height: 96,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, progress) {
              double? value;
              var expectedBytes = progress?.expectedTotalBytes;
              if (progress != null && expectedBytes != null) {
                value = progress.cumulativeBytesLoaded / expectedBytes;
              }
              return CircularProgressIndicator(value: value);
            },
            errorBuilder: (context, error, stacktrace) =>
                const Icon(Icons.error),
          ),
          Text(
            name[0].toUpperCase() + name.substring(1),
            style: GoogleFonts.dmSerifDisplay(
              textStyle: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const SizedBox()
        ],
      ),
    );
  }
}
