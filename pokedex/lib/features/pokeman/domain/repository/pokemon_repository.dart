import 'package:dartz/dartz.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getInitialPokeMons();
  Future<Either<Failure, List<Pokemon>>> getMorePokeMons({required int offset});
  Future<Either<Failure, SuccessEntity>> addPokemonToFavoritesLocal({
    required Pokemon pokemon,
  });
  Future<Either<Failure, SuccessEntity>> removePokemonFromFavoritesLocal({
    required Pokemon pokemon,
  });
}
