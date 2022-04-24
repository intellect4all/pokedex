import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/constants/strings.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/usecases/add_pokemon_to_favorites_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_initial_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_more_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/remove_pokemon_from_favorites_local_usecase.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';

import 'pokemon_bloc_test.mocks.dart';

@GenerateMocks([
  GetInitialPokemonsUseCase,
  GetMorePokemonsUseCase,
  AddPokemonToFavoritesLocalUseCase,
  RemovePokemonFromFavoritesLocalUseCase,
])
void main() {
  late PokemonBloc bloc;
  late MockGetInitialPokemonsUseCase mockGetInitialPokemonsUseCase;
  late MockGetMorePokemonsUseCase mockGetMorePokemonsUseCase;
  late MockAddPokemonToFavoritesLocalUseCase
      mockAddPokemonToFavoritesLocalUseCase;
  late MockRemovePokemonFromFavoritesLocalUseCase
      mockRemovePokemonFromFavoritesLocalUseCase;

  setUp(() {
    mockGetInitialPokemonsUseCase = MockGetInitialPokemonsUseCase();
    mockGetMorePokemonsUseCase = MockGetMorePokemonsUseCase();
    mockAddPokemonToFavoritesLocalUseCase =
        MockAddPokemonToFavoritesLocalUseCase();
    mockRemovePokemonFromFavoritesLocalUseCase =
        MockRemovePokemonFromFavoritesLocalUseCase();
    bloc = PokemonBloc(
      getInitialPokemonsUseCase: mockGetInitialPokemonsUseCase,
      getMorePokemonsUseCase: mockGetMorePokemonsUseCase,
      addPokemonToFavoritesLocalUseCase: mockAddPokemonToFavoritesLocalUseCase,
      removePokemonFromFavoritesLocalUseCase:
          mockRemovePokemonFromFavoritesLocalUseCase,
    );
  });

  test(
    'should check that initial state is [PokemonInitialState()]',
    () async {
      // assert
      expect(bloc.state, equals(PokemonInitialState()));
    },
  );

  group('GetInitialPokemons', () {
    final tLoadInitialPokemonsEvent = LoadInitialPokemonsEvent();
    test(
      'should get initial pokemons from use case',
      () async {
        // arrange
        when(mockGetInitialPokemonsUseCase(any))
            .thenAnswer((_) async => Right(tPokemons));

        // act
        bloc.add(tLoadInitialPokemonsEvent);
        await untilCalled(mockGetInitialPokemonsUseCase(any));

        // assert
        verify(mockGetInitialPokemonsUseCase(NoParams()));
      },
    );

    test(
      'should emit a [LoadingPokemonsState, PokemonsLoadedState] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetInitialPokemonsUseCase(any))
            .thenAnswer((_) async => Right(tPokemons));

        // assert later
        final expected = [
          LoadingPokemonsState(),
          PokemonsLoadedState(pokemons: tPokemons),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(tLoadInitialPokemonsEvent);
      },
    );

    test(
      'should emit a [LoadingPokemonsState, LoadPokemonErrorState] when Failure is returned',
      () async {
        // arrange
        when(mockGetInitialPokemonsUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingPokemonsState(),
          const LoadInitialPokemonErrorState(
              message: LOAD_INITIAL_POKEMONS_FAILURE_MESSAGE)
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(tLoadInitialPokemonsEvent);
      },
    );
  });

  group('GetMorePokemons', () {
    const tLoadMorePokemonsParams = LoadMorePokemonsParams(offset: 2);
    const tLoadMorePokemonsEvent = LoadMorePokemonsEvent(offset: 2);
    test(
      'should get more pokemons from use case',
      () async {
        // arrange
        when(mockGetMorePokemonsUseCase(any))
            .thenAnswer((_) async => Right(tPokemons));

        // act
        bloc.add(tLoadMorePokemonsEvent);
        await untilCalled(mockGetMorePokemonsUseCase(any));

        // assert
        verify(mockGetMorePokemonsUseCase(tLoadMorePokemonsParams));
      },
    );

    test(
      'should emit a [LoadingPokemonsState, PokemonsLoadedState] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetMorePokemonsUseCase(any))
            .thenAnswer((_) async => Right(tPokemons));

        // assert later
        final expected = [
          LoadingPokemonsState(),
          PokemonsLoadedState(pokemons: tPokemons),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(tLoadMorePokemonsEvent);
      },
    );

    test(
      'should emit a [LoadingPokemonsState, LoadPokemonErrorState] when Failure is returned',
      () async {
        // arrange
        when(mockGetMorePokemonsUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingPokemonsState(),
          const LoadMorePokemonErrorState(
              message: LOAD_MORE_POKEMONS_FAILURE_MESSAGE)
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(tLoadMorePokemonsEvent);
      },
    );
  });
}

List<Pokemon> get tPokemons => [
      const Pokemon(
        name: 'name 1',
        id: 1,
        height: 0,
        weight: 10,
        types: ['grass'],
        stats: AllStats(
          attack: BaseStatType(name: 'attack', value: 2),
          defense: BaseStatType(name: 'defense', value: 2),
          specialAttack: BaseStatType(name: 'special-attack', value: 2),
          specialDefense: BaseStatType(name: 'special-defense', value: 2),
          speed: BaseStatType(name: 'speed', value: 2),
          hp: BaseStatType(name: 'hp', value: 2),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      ),
      const Pokemon(
        name: 'name 2',
        id: 2,
        height: 0,
        weight: 10,
        types: ['grass'],
        stats: AllStats(
          attack: BaseStatType(name: 'attack', value: 2),
          defense: BaseStatType(name: 'defense', value: 2),
          specialAttack: BaseStatType(name: 'special-attack', value: 2),
          specialDefense: BaseStatType(name: 'special-defense', value: 2),
          speed: BaseStatType(name: 'speed', value: 2),
          hp: BaseStatType(name: 'hp', value: 2),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      )
    ];
