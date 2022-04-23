import 'package:dartz/dartz.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';

class GetInitialPokemonsUseCase extends UseCase<List<Pokemon>, NoParams> {
  final PokemonRepository repository;
  GetInitialPokemonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pokemon>>> call(NoParams params) async {
    return await repository.getInitialPokeMons();
  }
}
