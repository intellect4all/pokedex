import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';

class PokemonRepositoryImpl extends PokemonRepository {
  @override
  Future<Either<Failure, SuccessEntity>> addPokemonToFavoritesLocal(
      {required Pokemon pokemon}) {
    // TODO: implement addPokemonToFavoritesLocal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getInitialPokeMans() {
    // TODO: implement getInitialPokeMans
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Pokemon>>> getMorePokeMans(
      {required int offset}) {
    // TODO: implement getMorePokeMans
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SuccessEntity>> removePokemonFromFavoritesLocal(
      {required Pokemon pokemon}) {
    // TODO: implement removePokemonFromFavoritesLocal
    throw UnimplementedError();
  }
}
