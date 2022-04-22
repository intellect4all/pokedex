import 'package:equatable/equatable.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';

class RemovePokemonFromFavoritesLocalUseCase
    extends UseCase<SuccessEntity, RemovePokemonFromFavoritesLocalParams> {
  final PokemonRepository repository;
  RemovePokemonFromFavoritesLocalUseCase(this.repository);
  @override
  Future<Either<Failure, SuccessEntity>> call(params) async {
    return await repository.removePokemonFromFavoritesLocal(
        pokemon: params.pokemon);
  }
}

class RemovePokemonFromFavoritesLocalParams extends Equatable {
  final Pokemon pokemon;
  const RemovePokemonFromFavoritesLocalParams({required this.pokemon});

  @override
  List<Object?> get props => [pokemon];
}
