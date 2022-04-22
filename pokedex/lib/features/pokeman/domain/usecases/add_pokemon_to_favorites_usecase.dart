import 'package:equatable/equatable.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';

class AddPokemonToFavoritesLocalUseCase
    extends UseCase<SuccessEntity, AddToFavoritesParams> {
  final PokemonRepository repository;

  AddPokemonToFavoritesLocalUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessEntity>> call(params) {
    return repository.addPokemonToFavoritesLocal(pokemon: params.pokemon);
  }
}

class AddToFavoritesParams extends Equatable {
  final Pokemon pokemon;
  const AddToFavoritesParams({
    required this.pokemon,
  });

  @override
  List<Object?> get props => [pokemon];
}
