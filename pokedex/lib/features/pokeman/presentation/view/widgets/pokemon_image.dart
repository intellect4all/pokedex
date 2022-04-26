import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';

class PokemonImageWidget extends StatelessWidget {
  const PokemonImageWidget({
    Key? key,
    required this.pokemon,
    required this.size,
  }) : super(key: key);
  final Size size;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pokemon.id,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: CachedNetworkImage(
          imageUrl: pokemon.imageUrl,
          placeholder: (_, __) => Container(
            height: size.height,
            width: size.width,
            color: const Color(0xFFF3F9EF),
            child: CircularProgressIndicator(
              backgroundColor: AppColors.ceruleanBlue.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.ceruleanBlue),
            ),
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
