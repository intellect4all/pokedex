import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_more_pokemons_usecase.dart';

import '../../../data/repository/pokeman_repo_impl.dart';
import 'get_more_pokemons_usecase_test.mocks.dart';

@GenerateMocks([PokemonRepositoryImpl])
void main() {
  late GetMorePokemonsUseCase getMorePokemonsUseCase;
  late PokemonRepositoryImpl mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepositoryImpl();
    getMorePokemonsUseCase = GetMorePokemonsUseCase(mockPokemonRepository);
  });

  final tPokemons = [
    Pokemon(
      name: 'name',
      id: 'id',
      height: 0,
      weight: 10,
      type: const ['grass'],
      stats: AllStats(
        attack: BaseStatType(name: 'attack', value: 2),
        defense: BaseStatType(name: 'defense', value: 2),
        specialAttack: BaseStatType(name: 'specialAttack', value: 2),
        specialDefense: BaseStatType(name: 'specialDefense', value: 2),
        speed: BaseStatType(name: 'speed', value: 2),
        hp: BaseStatType(name: 'hp', value: 2),
      ),
      imageUrl: 'imageUrl',
      isFavourite: false,
    ),
    Pokemon(
      name: 'name',
      id: 'id',
      height: 0,
      weight: 10,
      type: const ['grass'],
      stats: AllStats(
        attack: BaseStatType(name: 'attack', value: 2),
        defense: BaseStatType(name: 'defense', value: 2),
        specialAttack: BaseStatType(name: 'specialAttack', value: 2),
        specialDefense: BaseStatType(name: 'specialDefense', value: 2),
        speed: BaseStatType(name: 'speed', value: 2),
        hp: BaseStatType(name: 'hp', value: 2),
      ),
      imageUrl: 'imageUrl',
      isFavourite: false,
    )
  ];
  test(
    'should get more Pokemons from the api',
    () async {
      // arrange
      when(mockPokemonRepository.getMorePokeMans(offset: 10))
          .thenAnswer((_) async => Right(tPokemons));
      const params = LoadMorePokemonsParams(offset: 10);

      // act
      final result = await getMorePokemonsUseCase(params);

      // assert
      expect(result, Right(tPokemons));

      verify(mockPokemonRepository.getMorePokeMans(offset: 10));

      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
