import 'package:hive_flutter/hive_flutter.dart';

import 'package:pokedex/core/constants/keys.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getCachedFavoritePokemons();

  Future<SuccessEntity> cacheFavoritePokemon(PokemonModel pokemonToCache);

  Future<SuccessEntity> removeFavoritePokemon(PokemonModel pokemonToBeRemoved);
}

class HiveBoxes {
  final Box favouritePokemonBox;
  HiveBoxes({
    required this.favouritePokemonBox,
  });
}

class PokemonLocalDataSourceImpl extends PokemonLocalDataSource {
  final HiveBoxes hiveBoxes;
  PokemonLocalDataSourceImpl({required this.hiveBoxes});

  @override
  Future<List<PokemonModel>> getCachedFavoritePokemons() async {
    try {
      if (hiveBoxes.favouritePokemonBox.isOpen) {
        if (hiveBoxes.favouritePokemonBox.isNotEmpty) {
          final cachedPokemons = hiveBoxes.favouritePokemonBox.values.toList();
          return List.generate(cachedPokemons.length,
              (index) => PokemonModel.fromJson(cachedPokemons[index]));
        } else {
          throw CacheException();
        }
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<SuccessEntity> cacheFavoritePokemon(PokemonModel pokemonToCache) {
    // TODO: implement cacheFavoritePokemon
    throw UnimplementedError();
  }

  @override
  Future<SuccessEntity> removeFavoritePokemon(PokemonModel pokemonToBeRemoved) {
    // TODO: implement removeFavoritePokemon
    throw UnimplementedError();
  }
}
