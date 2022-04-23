import 'package:pokedex/features/pokeman/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

class FakePokemonRemoteDataSource implements PokemonRemoteDataSource {
  @override
  Future<List<PokemonModel>> getInitialPokeMans() {
    throw UnimplementedError();
  }

  @override
  Future<List<PokemonModel>> getMorePokemons({required int offset}) {
    throw UnimplementedError();
  }
}
