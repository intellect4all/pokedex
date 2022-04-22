import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/usecases/add_pokemon_to_favorites_usecase.dart';

import '../../../data/repository/pokeman_repo_impl.dart';
import 'add_pokemon_to_favorites_local_usecase_test.mocks.dart';

@GenerateMocks([PokemonRepositoryImpl])
void main() {
  late AddPokemonToFavoritesLocalUseCase addToFavoritesUseCase;
  late PokemonRepositoryImpl mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepositoryImpl();
    addToFavoritesUseCase =
        AddPokemonToFavoritesLocalUseCase(mockPokemonRepository);
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
    'should test that a success entity is returned from [AddToFavoritesLocalUseCase]',
    () async {
      // arrange
      when(mockPokemonRepository.addPokemonToFavoritesLocal(pokemon: tPokemon))
          .thenAnswer(
              (_) async => const Right(SuccessEntity(message: 'success')));
      final params = AddToFavoritesParams(pokemon: tPokemon);
      // act
      final result = await addToFavoritesUseCase(params);
      // assert

      expect(result, const Right(SuccessEntity(message: 'success')));
      verify(
          mockPokemonRepository.addPokemonToFavoritesLocal(pokemon: tPokemon));
      verifyNoMoreInteractions(mockPokemonRepository);
    },
  );
}
