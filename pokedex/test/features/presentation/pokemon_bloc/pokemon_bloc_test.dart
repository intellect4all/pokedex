import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/constants/strings.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';
import 'package:pokedex/features/pokeman/domain/usecases/add_pokemon_to_favorites_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_initial_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_more_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/remove_pokemon_from_favorites_local_usecase.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_helper.dart';

import 'pokemon_bloc_test.mocks.dart';

@GenerateMocks([
  GetInitialPokemonsUseCase,
  GetMorePokemonsUseCase,
  AddPokemonToFavoritesLocalUseCase,
  RemovePokemonFromFavoritesLocalUseCase,
  PokemonHelper,
])
void main() {
  late PokemonBloc bloc;
  late MockGetInitialPokemonsUseCase mockGetInitialPokemonsUseCase;
  late MockGetMorePokemonsUseCase mockGetMorePokemonsUseCase;
  late MockAddPokemonToFavoritesLocalUseCase
      mockAddPokemonToFavoritesLocalUseCase;
  late MockRemovePokemonFromFavoritesLocalUseCase
      mockRemovePokemonFromFavoritesLocalUseCase;
  late MockPokemonHelper mockPokemonHelper;
  setUp(() {
    mockGetInitialPokemonsUseCase = MockGetInitialPokemonsUseCase();
    mockGetMorePokemonsUseCase = MockGetMorePokemonsUseCase();
    mockAddPokemonToFavoritesLocalUseCase =
        MockAddPokemonToFavoritesLocalUseCase();
    mockRemovePokemonFromFavoritesLocalUseCase =
        MockRemovePokemonFromFavoritesLocalUseCase();
    mockPokemonHelper = MockPokemonHelper();
    bloc = PokemonBloc(
      getInitialPokemonsUseCase: mockGetInitialPokemonsUseCase,
      getMorePokemonsUseCase: mockGetMorePokemonsUseCase,
      addPokemonToFavoritesLocalUseCase: mockAddPokemonToFavoritesLocalUseCase,
      removePokemonFromFavoritesLocalUseCase:
          mockRemovePokemonFromFavoritesLocalUseCase,
      pokemonHelper: mockPokemonHelper,
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

  group('AddPokemonToFavorite', () {
    const tPokemon = Pokemon(
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
    );

    addTestAddPokemonToFavoriteEventToBloc() {
      bloc.add(AddPokemonToFavoriteEvent(
          pokemonToFavorite: tPokemon, currentPokemons: tPokemons));
    }

    setUpMockPokemonHelper() {
      when(mockPokemonHelper.changePokemonFavoriteState(
              isFavorite: anyNamed('isFavorite'),
              pokemon: anyNamed('pokemon'),
              pokemons: anyNamed('pokemons')))
          .thenReturn(expectedPokemonsForAddToFavorites);
    }

    setUpMockAddToFavoriteUsecase() {
      when(mockAddPokemonToFavoritesLocalUseCase(any))
          .thenAnswer((_) async => Right(SuccessEntity()));
    }

    test(
      'should add pokemon to favorite in local',
      () async {
        // arrange
        setUpMockAddToFavoriteUsecase();
        setUpMockPokemonHelper();
        // act
        addTestAddPokemonToFavoriteEventToBloc();
        await untilCalled(mockAddPokemonToFavoritesLocalUseCase(any));

        // assert
        verify(mockAddPokemonToFavoritesLocalUseCase(
            const AddToFavoritesParams(pokemon: tPokemon)));
      },
    );

    test(
      'should update the current list of pokemons',
      () async {
        // arrange
        setUpMockAddToFavoriteUsecase();
        setUpMockPokemonHelper();

        // act
        addTestAddPokemonToFavoriteEventToBloc();
        await untilCalled(mockPokemonHelper.changePokemonFavoriteState(
            isFavorite: true, pokemon: tPokemon, pokemons: tPokemons));

        // assert
        verify(mockPokemonHelper.changePokemonFavoriteState(
            pokemon: tPokemon, isFavorite: true, pokemons: tPokemons));
      },
    );
    test(
      'should emit a [PokemonAddedToFavoriteState] when success entity is returned',
      () async {
        // arrange
        setUpMockAddToFavoriteUsecase();
        setUpMockPokemonHelper();

        // assert later
        final expected = [
          PokemonAddedToFavoriteState(
              pokemon: tPokemon,
              newPokemons: expectedPokemonsForAddToFavorites),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        addTestAddPokemonToFavoriteEventToBloc();
      },
    );

    test(
      'should emit a [FavoritePokemonsErrorState] when Failure is returned',
      () async {
        // arrange

        when(mockAddPokemonToFavoritesLocalUseCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        setUpMockPokemonHelper();

        // assert later
        final expected = [
          const FavoritePokemonsErrorState(
              message: ADD_TO_FAVORITES_ERROR_MESSAGE)
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        addTestAddPokemonToFavoriteEventToBloc();
      },
    );
  });

  group('RemovePokemonFromFavorite', () {
    const tPokemon = Pokemon(
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
      isFavorite: true,
    );

    addTestRemoveFromFavoriteEventToBloc() {
      bloc.add(RemovePokemonFromFavoriteEvent(
        pokemon: tPokemon,
        currentPokemons: tPokemonsForRemoveFromFavorites,
      ));
    }

    setUpMockPokemonHelper() {
      when(mockPokemonHelper.changePokemonFavoriteState(
              isFavorite: anyNamed('isFavorite'),
              pokemon: anyNamed('pokemon'),
              pokemons: anyNamed('pokemons')))
          .thenReturn(expectedPokemonsForRemoveFromFavorites);
    }

    setUpMockRemoveFromFavoriteUsecase() {
      when(mockRemovePokemonFromFavoritesLocalUseCase(any))
          .thenAnswer((_) async => Right(SuccessEntity()));
    }

    test(
      'should remove pokemon from favorite in local',
      () async {
        // arrange
        setUpMockRemoveFromFavoriteUsecase();
        setUpMockPokemonHelper();
        // act
        addTestRemoveFromFavoriteEventToBloc();
        await untilCalled(mockRemovePokemonFromFavoritesLocalUseCase(any));

        // assert
        verify(mockRemovePokemonFromFavoritesLocalUseCase(
            const RemovePokemonFromFavoritesLocalParams(pokemon: tPokemon)));
      },
    );

    test(
      'should update the current list of pokemons',
      () async {
        // arrange
        setUpMockRemoveFromFavoriteUsecase();
        setUpMockPokemonHelper();

        // act
        addTestRemoveFromFavoriteEventToBloc();
        await untilCalled(mockPokemonHelper.changePokemonFavoriteState(
            isFavorite: false,
            pokemon: tPokemon,
            pokemons: tPokemonsForRemoveFromFavorites));

        // assert
        verify(mockPokemonHelper.changePokemonFavoriteState(
          pokemon: tPokemon,
          isFavorite: false,
          pokemons: tPokemonsForRemoveFromFavorites,
        ));
      },
    );
    test(
      'should emit a [PokemonRemovedFromFavoriteState] when success entity is returned',
      () async {
        // arrange
        setUpMockRemoveFromFavoriteUsecase();
        setUpMockPokemonHelper();

        // assert later
        final expected = [
          PokemonRemovedFromFavoriteState(
            pokemon: tPokemon,
            newPokemons: expectedPokemonsForRemoveFromFavorites,
          ),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        addTestRemoveFromFavoriteEventToBloc();
      },
    );

    test(
      'should emit a [FavoritePokemonsErrorState] when Failure is returned',
      () async {
        // arrange

        when(mockRemovePokemonFromFavoritesLocalUseCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        setUpMockPokemonHelper();

        // assert later
        final expected = [
          const FavoritePokemonsErrorState(
              message: REMOVE_FROM_FAVORITES_ERROR_MESSAGE)
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        addTestRemoveFromFavoriteEventToBloc();
      },
    );
  });
}

List<Pokemon> get expectedPokemonsForRemoveFromFavorites => [
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
        isFavorite:
            false, // * note that is favorite should now be changed to false
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

List<Pokemon> get tPokemonsForRemoveFromFavorites => [
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
        isFavorite: true, // * note that isFavorite is true
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

List<Pokemon> get expectedPokemonsForAddToFavorites => [
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
        isFavorite:
            true, // * note that is favorite should now be changed to true
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
        isFavorite: false, // * note that isFavorite is false
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
