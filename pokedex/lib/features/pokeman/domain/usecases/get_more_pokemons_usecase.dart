import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';

class GetMorePokemonsUseCase
    extends UseCase<List<Pokemon>, LoadMorePokemonsParams> {
  final PokemonRepository repository;
  GetMorePokemonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pokemon>>> call(params) async {
    return await repository.getMorePokemons(offset: params.offset);
  }
}

class LoadMorePokemonsParams extends Equatable {
  final int offset;
  const LoadMorePokemonsParams({
    required this.offset,
  });

  @override
  List<Object?> get props => [offset];
}
