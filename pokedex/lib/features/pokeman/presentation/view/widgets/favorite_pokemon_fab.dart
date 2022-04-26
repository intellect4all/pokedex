import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';

class FavoritePokemonFAB extends StatefulWidget {
  final Pokemon pokemon;
  const FavoritePokemonFAB({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<FavoritePokemonFAB> createState() => _FavoritePokemonFABState();
}

class _FavoritePokemonFABState extends State<FavoritePokemonFAB> {
  bool isMarkedAsFavorite = false;

  @override
  void initState() {
    isMarkedAsFavorite = widget.pokemon.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PokemonBloc, PokemonState>(
      listener: (context, state) {
        if (state is PokemonAddedToFavoriteState) {
          if (state.pokemon.id == widget.pokemon.id) {
            setState(() {
              isMarkedAsFavorite = true;
            });
          }
        } else if (state is PokemonRemovedFromFavoriteState) {
          if (state.pokemon.id == widget.pokemon.id) {
            setState(() {
              isMarkedAsFavorite = false;
            });
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: _handleOnTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: isMarkedAsFavorite
                  ? AppColors.paleLavendar
                  : AppColors.ceruleanBlue,
            ),
            child: Text(
              isMarkedAsFavorite
                  ? 'Remove from favourites'
                  : 'Mark as favourite',
              style: TextStyle(
                color:
                    isMarkedAsFavorite ? AppColors.ceruleanBlue : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleOnTap() {
    if (isMarkedAsFavorite) {
      _removePokemonFromFavorite();
    } else {
      _markPokemonAsFavorite();
    }
  }

  void _markPokemonAsFavorite() {
    BlocProvider.of<PokemonBloc>(context).add(
      AddPokemonToFavoriteEvent(
        pokemonToFavorite: widget.pokemon,
      ),
    );
  }

  void _removePokemonFromFavorite() {
    BlocProvider.of<PokemonBloc>(context).add(
      RemovePokemonFromFavoriteEvent(
        pokemon: widget.pokemon,
      ),
    );
  }
}
