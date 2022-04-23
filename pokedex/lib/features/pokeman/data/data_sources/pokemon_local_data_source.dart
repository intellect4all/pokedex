import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getCachedFavoritePokemons();

  Future<void> cacheFavoritePokemon(PokemonModel pokemonToCache);
}
