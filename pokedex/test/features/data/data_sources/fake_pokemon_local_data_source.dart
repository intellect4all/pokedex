import 'package:pokedex/features/pokeman/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

class FakePokemonLocalDataSource implements PokemonLocalDataSource {
  @override
  Future<void> cacheFavoritePokemon(PokemonModel pokemonToCache) {
    throw UnimplementedError();
  }

  @override
  Future<List<PokemonModel>> getCachedFavoritePokemons() {
    throw UnimplementedError();
  }
}
