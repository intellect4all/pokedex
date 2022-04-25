import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:string_extensions/string_extensions.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    Key? key,
    required this.pokemon,
    required int index,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log(pokemon.toString());
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        constraints: const BoxConstraints(
          maxWidth: 120,
          maxHeight: 220,
        ),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFFF3F9EF),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  placeholder: (_, __) => Container(
                    height: 100,
                    width: 100,
                    color: Color(0xFFF3F9EF),
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.ceruleanBlue.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.ceruleanBlue),
                    ),
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPokemonId(),
                Text(
                  pokemon.name.toTitleCase!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ).space(bottom: 10),
                _buildPokemonTypes(),
              ],
            ).space(left: 10, right: 10, bottom: 10, top: 10)
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonTypes() {
    String types = pokemon.types.join(', ').toTitleCase!;
    return Text(
      types,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.dimGray,
      ),
    );
  }

  Widget _buildPokemonId() {
    //* this code will duplicate '0' by the remainder times;
    String duplicateO = '0' * (4 - (pokemon.id.toString().length));
    // concatenation to give the format '#0001'
    String formattedId = '#$duplicateO${pokemon.id}';
    return Text(
      formattedId,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.dimGray,
      ),
    ).space(bottom: 2);
  }
}
