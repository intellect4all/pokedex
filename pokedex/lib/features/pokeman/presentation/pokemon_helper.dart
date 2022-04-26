import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';

class PokemonHelper {
  List<Pokemon> changePokemonFavoriteState({
    required Pokemon pokemon,
    required bool isFavorite,
    required List<Pokemon> pokemons,
  }) {
    if (pokemons.isEmpty) return [];
    List<Pokemon> newPokemons = List.from(pokemons);

    // convert the Pokemon to a PokemonModel to use the copyWith functionality
    final pokemonModel = PokemonModel.fromPokemon(pokemon);

    int index = pokemons.indexWhere((element) => element.id == pokemon.id);

    if (index > -1) {
      newPokemons[index] = pokemonModel.copyWith(isFavorite: isFavorite);
      return newPokemons;
    } else {
      return pokemons;
    }
  }

  Iterable<Pokemon> cleansPokemons({
    required List<Pokemon> newPokemons,
    required List<Pokemon> currentPokemons,
  }) {
    List<Pokemon> cleansedPokemon = [];
    cleansedPokemon.addAll(currentPokemons);
    for (var pokemon in newPokemons) {
      cleansedPokemon.removeWhere((element) => element.id == pokemon.id);
    }

    cleansedPokemon.addAll(newPokemons);

    cleansedPokemon.sort(((a, b) => a.id.compareTo(b.id)));
    return cleansedPokemon;
  }
}
