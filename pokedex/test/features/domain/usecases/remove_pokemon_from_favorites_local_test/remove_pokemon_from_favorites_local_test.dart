import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/usecases/remove_pokemon_from_favorites_local_usecase.dart';

import '../../../data/repository/pokeman_repo_impl.dart';
import 'remove_pokemon_from_favorites_local_test.mocks.dart';

@GenerateMocks([PokemonRepositoryImpl])
void main() {
  late RemovePokemonFromFavoritesLocalUseCase
      removePokemonFromFavoritesLocalUseCase;
  late MockPokemonRepositoryImpl mockPokemonRepositoryImpl;

  setUp(() {
    mockPokemonRepositoryImpl = MockPokemonRepositoryImpl();
    removePokemonFromFavoritesLocalUseCase =
        RemovePokemonFromFavoritesLocalUseCase(mockPokemonRepositoryImpl);
  });

  final tPokemon = Pokemon(
    name: 'name',
    id: 1,
    height: 0,
    weight: 10,
    types: const ['grass'],
    stats: AllStats(
      attack: BaseStatType(name: 'attack', value: 2),
      defense: BaseStatType(name: 'defense', value: 2),
      specialAttack: BaseStatType(name: 'specialAttack', value: 2),
      specialDefense: BaseStatType(name: 'specialDefense', value: 2),
      speed: BaseStatType(name: 'speed', value: 2),
      hp: BaseStatType(name: 'hp', value: 2),
    ),
    imageUrl: 'imageUrl',
    isFavorite: false,
  );
  test(
    'should test that a success entity is returned from RemovePokemonFromFavoritesLocalUseCase',
    () async {
      // arrange
      when(mockPokemonRepositoryImpl.removePokemonFromFavoritesLocal(
              pokemon: tPokemon))
          .thenAnswer(
        (_) async => const Right(
          SuccessEntity(message: 'successfully removed'),
        ),
      );

      final removePokemonParams =
          RemovePokemonFromFavoritesLocalParams(pokemon: tPokemon);

      // act
      final result =
          await removePokemonFromFavoritesLocalUseCase(removePokemonParams);

      // assert
      expect(
          result, const Right(SuccessEntity(message: 'successfully removed')));

      verify(mockPokemonRepositoryImpl.removePokemonFromFavoritesLocal(
          pokemon: tPokemon));

      verifyNoMoreInteractions(mockPokemonRepositoryImpl);
    },
  );
}
