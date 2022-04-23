import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// calls https://pokeapi.co/api/v2/pokemon for the initial list of pokemons
  ///
  /// then calls the returned [url] to fetch pokemon details
  /// pokemon details for each returned data
  ///
  /// throws a [ServerException] for all failed responses
  Future<List<PokemonModel>> getInitialPokeMans();

  /// calls https://pokeapi.co/api/v2/pokemon?limit=[FETCH_LIMIT]&offset=[offset] for the fetch paginated list of pokemons
  ///
  /// then calls the returned [url] to fetch pokemon details
  /// pokemon details for each returned data
  ///
  /// [FETCH_LIMIT] is 20 by default
  ///
  /// throws a [ServerException] for failed responses
  Future<List<PokemonModel>> getMorePokeMans({
    required int offset,
  });
}
