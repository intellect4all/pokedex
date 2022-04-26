import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/data/repositories/pokemon_repository_implementation.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_initial_pokemons_usecase.dart';

import 'get_initial_pokemons_usecase_test.mocks.dart';

@GenerateMocks([PokemonRepositoryImpl])
void main() {
  late GetInitialPokemonsUseCase getInitialPokemonsUseCase;
  late MockPokemonRepositoryImpl mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepositoryImpl();
    getInitialPokemonsUseCase =
        GetInitialPokemonsUseCase(mockPokemonRepository);
  });

  const tPokemons = [
    Pokemon(
      name: 'name',
      id: 1,
      height: 0,
      weight: 10,
      types: ['grass'],
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
    ),
    Pokemon(
      name: 'name',
      id: 2,
      height: 0,
      weight: 10,
      types: ['grass'],
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
    )
  ];
  test(
    'should get initial Pokemons from the api',
    () async {
      // arrange
      when(mockPokemonRepository.getInitialPokeMons())
          .thenAnswer((_) async => const Right(tPokemons));

      // act
      final result = await getInitialPokemonsUseCase(NoParams());
      // assert

      expect(result, const Right(tPokemons));

      verify(mockPokemonRepository.getInitialPokeMons());

      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
