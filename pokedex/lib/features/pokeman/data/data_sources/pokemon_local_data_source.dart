import 'package:hive_flutter/hive_flutter.dart';

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

  Box get favoritePokemonsBox => hiveBoxes.favouritePokemonBox;

  @override
  Future<List<PokemonModel>> getCachedFavoritePokemons() async {
    try {
      if (favoritePokemonsBox.isOpen) {
        if (favoritePokemonsBox.isNotEmpty) {
          final cachedPokemons = favoritePokemonsBox.values.toList();
          return List.generate(cachedPokemons.length,
              (index) => PokemonModel.fromJson(cachedPokemons[index]));
        }
      }
      throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<SuccessEntity> cacheFavoritePokemon(
      PokemonModel pokemonToCache) async {
    try {
      await favoritePokemonsBox.put(pokemonToCache.id, pokemonToCache.toJson());
      return SuccessEntity();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<SuccessEntity> removeFavoritePokemon(
      PokemonModel pokemonToBeRemoved) async {
    try {
      await favoritePokemonsBox.delete(pokemonToBeRemoved.id);
      return SuccessEntity();
    } catch (e) {
      throw CacheException();
    }
  }
}
