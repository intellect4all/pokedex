import 'dart:developer';

import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/core/utils/network_info/network_info.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';

class PokemonRepositoryImpl extends PokemonRepository {
  final NetworkInfo networkInfo;
  final PokemonLocalDataSource localDataSource;
  final PokemonRemoteDataSource remoteDataSource;
  PokemonRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Pokemon>>> getInitialPokeMons() async {
    List<Pokemon> pokemons = [];
    List<PokemonModel> remotePokemons = [];
    List<PokemonModel> cachedFavoritePokemons = [];
    if (await networkInfo.isConnected) {
      try {
        remotePokemons = await remoteDataSource.getInitialPokeMans();
        pokemons = remotePokemons;
        try {
          cachedFavoritePokemons =
              await localDataSource.getCachedFavoritePokemons();
        } on CacheException {
          log('Cache failure encountered');
        }
        if (cachedFavoritePokemons.isNotEmpty) {
          for (PokemonModel favoritePokemon in cachedFavoritePokemons) {
            int ind = remotePokemons
                .indexWhere((element) => element.id == favoritePokemon.id);

            if (ind > -1) {
              pokemons[ind] = remotePokemons[ind].copyWith(isFavorite: true);
            } else {
              pokemons.add(favoritePokemon);
            }
          }
        }

        return Right(pokemons);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(DeviceOfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getMorePokemons(
      {required int offset}) async {
    List<Pokemon> pokemons = [];
    List<PokemonModel> remotePokemons = [];
    List<PokemonModel> cachedFavoritePokemons = [];

    networkInfo.isConnected;

    try {
      remotePokemons = await remoteDataSource.getMorePokemons(offset: offset);
      pokemons = remotePokemons;
      try {
        cachedFavoritePokemons =
            await localDataSource.getCachedFavoritePokemons();
      } on CacheException {
        log('Cache Exception');
      }
      if (cachedFavoritePokemons.isNotEmpty) {
        for (PokemonModel favoritePokemon in cachedFavoritePokemons) {
          int ind = remotePokemons
              .indexWhere((element) => element.id == favoritePokemon.id);

          if (ind > -1) {
            pokemons[ind] = remotePokemons[ind].copyWith(isFavorite: true);
          }
        }
      }
      return Right(pokemons);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SuccessEntity>> addPokemonToFavoritesLocal(
      {required Pokemon pokemon}) {
    // TODO: implement addPokemonToFavoritesLocal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SuccessEntity>> removePokemonFromFavoritesLocal(
      {required Pokemon pokemon}) {
    // TODO: implement removePokemonFromFavoritesLocal
    throw UnimplementedError();
  }
}
