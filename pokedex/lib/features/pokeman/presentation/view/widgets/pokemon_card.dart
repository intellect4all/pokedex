import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/presentation/view/pokemon_details_screen.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/pokemon_image.dart';
import 'package:string_extensions/string_extensions.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    Key? key,
    required this.pokemon,
    required this.pokemanIndex,
  }) : super(key: key);

  final int pokemanIndex;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPokemonDetailsScreen(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        // constraints: const BoxConstraints(
        //   maxWidth: 200,
        //   maxHeight: 220,
        // ),
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
              width: double.infinity,
              color: getColor(),
              child: ClipRRect(
                child: PokemonImageWidget(
                  pokemon: pokemon,
                  size: const Size(100, 100),
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
    return Text(
      HelperFunctions.joinListToString(pokemon.types),
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.dimGray,
      ),
    );
  }

  Widget _buildPokemonId() {
    final formattedId = HelperFunctions.formatPokemonId(pokemon.id);
    return Text(
      formattedId,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.dimGray,
      ),
    ).space(bottom: 2);
  }

  _navigateToPokemonDetailsScreen(BuildContext context) {
    Navigation.intentUsingWidget(
      context,
      PokemonDetailsScreen(
        pokemon: pokemon,
        color: getColor(),
      ),
      PokemonDetailsScreen.routeName,
    );
  }

  Color getColor() {
    final rem = (pokemanIndex + 1) % 9;

    if (rem == 0 || rem == 8 || rem == 7) {
      return AppColors.aliceBlue;
    } else if (rem == 4 || rem == 5 || rem == 6) {
      return AppColors.lavendarBlush;
    } else {
      return AppColors.honeyDew;
    }
  }
}
