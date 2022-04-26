import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/core/utils/network_info.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokeman/data/models/all_stats_model.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/data/repositories/pokemon_repository_implementation.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart';

import 'pokemon_repository_impl_test.mocks.dart';

@GenerateMocks([PokemonRemoteDataSource, PokemonLocalDataSource, NetworkInfo])
void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockPokemonLocalDataSource mockPokemonLocalDataSource;
  late MockPokemonRemoteDataSource mockPokemonRemoteDataSource;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockPokemonLocalDataSource = MockPokemonLocalDataSource();
    mockPokemonRemoteDataSource = MockPokemonRemoteDataSource();
    repository = PokemonRepositoryImpl(
      remoteDataSource: mockPokemonRemoteDataSource,
      localDataSource: mockPokemonLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getInitialPokemons', () {
    final tPokemonModels = [
      const PokemonModel(
        name: 'name 1',
        id: 1,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 50),
          modelDefense: BaseStatType(name: 'defense', value: 54),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 54),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 23),
          modelHp: BaseStatType(name: 'hp', value: 24),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      ),
      const PokemonModel(
        name: 'name 2',
        id: 2,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 23),
          modelDefense: BaseStatType(name: 'defense', value: 42),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 62),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 73),
          modelHp: BaseStatType(name: 'hp', value: 82),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      ),
    ];
    final List<Pokemon> tPokemons = tPokemonModels;
    final tCachedPokemonNotInRemote = [
      const PokemonModel(
        name: 'name 3',
        id: 3,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 44),
          modelDefense: BaseStatType(name: 'defense', value: 54),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 54),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 23),
          modelHp: BaseStatType(name: 'hp', value: 24),
        ),
        imageUrl: 'imageUrl',
        isFavorite: true,
      )
    ];
    final List<PokemonModel> tCachedFavoritePokemons = [
      const PokemonModel(
        name: 'name 1',
        id: 1,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 44),
          modelDefense: BaseStatType(name: 'defense', value: 54),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 54),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 23),
          modelHp: BaseStatType(name: 'hp', value: 24),
        ),
        imageUrl: 'imageUrl',
        isFavorite: true,
      )
    ];

    setUp(() {
      when(mockPokemonRemoteDataSource.getInitialPokemons())
          .thenAnswer((_) async => tPokemonModels);
      when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
          .thenAnswer((_) async => []);
    });
    test(
      'should check if there is internet connection on device',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getInitialPokeMons();

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should return remote pokemons data if there is internet connection on device',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenAnswer((_) async => tPokemonModels);
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => []);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          expect(result, equals(Right(tPokemons)));
        },
      );
      test(
        'should return a server failure when the pokemons could not be fetched',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenThrow(ServerException());

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should check localDataSource for cached favorites pokemons',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tPokemonModels);

          // act
          await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
        },
      );

      test(
        'should update favorite pokemons from the returned remote pokemons',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tCachedFavoritePokemons);
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          final List<Pokemon> expectedResponse = [
            const PokemonModel(
              name: 'name 1',
              id: 1,
              height: 20,
              weight: 10,
              types: ['grass'],
              stats: AllStatsModel(
                modelAttack: BaseStatType(name: 'attack', value: 50),
                modelDefense: BaseStatType(name: 'defense', value: 54),
                modelSpecialAttack:
                    BaseStatType(name: 'specialAttack', value: 54),
                modelSpecialDefense:
                    BaseStatType(name: 'specialDefense', value: 32),
                modelSpeed: BaseStatType(name: 'speed', value: 23),
                modelHp: BaseStatType(name: 'hp', value: 24),
              ),
              imageUrl: 'imageUrl',
              isFavorite: true,
            ),
            const PokemonModel(
              name: 'name 2',
              id: 2,
              height: 20,
              weight: 10,
              types: ['grass'],
              stats: AllStatsModel(
                modelAttack: BaseStatType(name: 'attack', value: 23),
                modelDefense: BaseStatType(name: 'defense', value: 42),
                modelSpecialAttack:
                    BaseStatType(name: 'specialAttack', value: 62),
                modelSpecialDefense:
                    BaseStatType(name: 'specialDefense', value: 32),
                modelSpeed: BaseStatType(name: 'speed', value: 73),
                modelHp: BaseStatType(name: 'hp', value: 82),
              ),
              imageUrl: 'imageUrl',
              isFavorite: false,
            ),
          ];

          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
          expect(result.fold((l) => null, (r) => r.first),
              equals(expectedResponse.first));
        },
      );

      test(
        'should not update returned pokemons if they are not in cache',
        () async {
          // arrange

          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tCachedPokemonNotInRemote);
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
          expect(result, equals(Right(tPokemons)));
        },
      );

      test(
        'should contain all favorite pokemons in the local data source',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async =>
                  [...tCachedFavoritePokemons, ...tCachedPokemonNotInRemote]);
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());

          final expected = result.fold((l) => null, (pokemons) => pokemons);

          expect(expected!.contains(tCachedPokemonNotInRemote.first), true);
        },
      );

      test(
        '''should throw, handle CacheException (by ignoring favorites pokemon check, as this should not affect remote pokemon)
        when no cached pokemon is available''',
        () async {
          // arrange

          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenThrow(CacheException());
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokemons());
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
          expect(result, equals(Right(tPokemons)));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should not call remote data source when device is offline',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenThrow(ServerException());

          // act
          await repository.getInitialPokeMons();

          // assert
          verifyZeroInteractions(mockPokemonRemoteDataSource);
        },
      );

      test(
        'should not check local data source device is offline',
        () async {
          // arrange

          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenThrow(CacheException());

          // act
          await repository.getInitialPokeMons();

          // assert
          verifyZeroInteractions(mockPokemonLocalDataSource);
        },
      );

      test(
        'should return DeviceOfflineFailure when device is offline',
        () async {
          // act
          final result = await repository.getInitialPokeMons();

          // assert
          expect(result, Left(DeviceOfflineFailure()));
        },
      );
    });
  });

  group('getMorePokemons', () {
    // * test variables initialization
    final tPokemonModels = [
      const PokemonModel(
        name: 'name 1',
        id: 1,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 50),
          modelDefense: BaseStatType(name: 'defense', value: 54),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 54),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 23),
          modelHp: BaseStatType(name: 'hp', value: 24),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      ),
      const PokemonModel(
        name: 'name 2',
        id: 2,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 23),
          modelDefense: BaseStatType(name: 'defense', value: 42),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 62),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 73),
          modelHp: BaseStatType(name: 'hp', value: 82),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      ),
    ];
    final List<Pokemon> tPokemons = tPokemonModels;
    final tCachedPokemonNotInRemote = [
      const PokemonModel(
        name: 'name 3',
        id: 3,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 44),
          modelDefense: BaseStatType(name: 'defense', value: 54),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 54),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 23),
          modelHp: BaseStatType(name: 'hp', value: 24),
        ),
        imageUrl: 'imageUrl',
        isFavorite: true,
      )
    ];
    final List<PokemonModel> tCachedFavoritePokemons = [
      const PokemonModel(
        name: 'name 1',
        id: 1,
        height: 20,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 44),
          modelDefense: BaseStatType(name: 'defense', value: 54),
          modelSpecialAttack: BaseStatType(name: 'specialAttack', value: 54),
          modelSpecialDefense: BaseStatType(name: 'specialDefense', value: 32),
          modelSpeed: BaseStatType(name: 'speed', value: 23),
          modelHp: BaseStatType(name: 'hp', value: 24),
        ),
        imageUrl: 'imageUrl',
        isFavorite: true,
      )
    ];

    const tOffset = 10;

    setUp(() {
      when(mockPokemonRemoteDataSource.getMorePokemons(
              offset: anyNamed('offset')))
          .thenAnswer((_) async => tPokemonModels);
      when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
          .thenAnswer((_) async => []);
    });
    test(
      'should check if there is internet connection on device',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getMorePokemons(offset: tOffset);

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should never call getInitialPokemons()',
        () async {
          //arrange
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenAnswer((_) async => tPokemonModels);

          // act
          await repository.getMorePokemons(offset: tOffset);

          // assert
          verifyNever(mockPokemonRemoteDataSource.getInitialPokemons());
        },
      );
      test(
        'should return more remote pokemons data if there is internet connection on device',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getMorePokemons(
                  offset: anyNamed('offset')))
              .thenAnswer((_) async => tPokemonModels);
          // when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
          //     .thenAnswer((_) async => []);

          // act
          final result = await repository.getMorePokemons(offset: tOffset);

          // assert
          verify(mockPokemonRemoteDataSource.getMorePokemons(offset: tOffset));
          expect(result, equals(Right(tPokemons)));
        },
      );
      test(
        'should return a server failure when the pokemons could not be fetched',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getMorePokemons(
                  offset: anyNamed('offset')))
              .thenThrow(ServerException());

          // act
          final result = await repository.getMorePokemons(offset: tOffset);

          // assert
          verify(mockPokemonRemoteDataSource.getMorePokemons(offset: tOffset));
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should check localDataSource for cached favorites pokemons',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tCachedFavoritePokemons);

          // act
          await repository.getMorePokemons(offset: tOffset);

          // assert
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
        },
      );

      test(
        'should update favorite pokemons from the returned remote pokemons',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tCachedFavoritePokemons);
          when(mockPokemonRemoteDataSource.getMorePokemons(
                  offset: anyNamed('offset')))
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getMorePokemons(offset: tOffset);

          // assert
          final List<Pokemon> expectedResponse = [
            const PokemonModel(
              name: 'name 1',
              id: 1,
              height: 20,
              weight: 10,
              types: ['grass'],
              stats: AllStatsModel(
                modelAttack: BaseStatType(name: 'attack', value: 50),
                modelDefense: BaseStatType(name: 'defense', value: 54),
                modelSpecialAttack:
                    BaseStatType(name: 'specialAttack', value: 54),
                modelSpecialDefense:
                    BaseStatType(name: 'specialDefense', value: 32),
                modelSpeed: BaseStatType(name: 'speed', value: 23),
                modelHp: BaseStatType(name: 'hp', value: 24),
              ),
              imageUrl: 'imageUrl',
              isFavorite: true,
            ),
            const PokemonModel(
              name: 'name 2',
              id: 2,
              height: 20,
              weight: 10,
              types: ['grass'],
              stats: AllStatsModel(
                modelAttack: BaseStatType(name: 'attack', value: 23),
                modelDefense: BaseStatType(name: 'defense', value: 42),
                modelSpecialAttack:
                    BaseStatType(name: 'specialAttack', value: 62),
                modelSpecialDefense:
                    BaseStatType(name: 'specialDefense', value: 32),
                modelSpeed: BaseStatType(name: 'speed', value: 73),
                modelHp: BaseStatType(name: 'hp', value: 82),
              ),
              imageUrl: 'imageUrl',
              isFavorite: false,
            ),
          ];

          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
          expect(result.fold((l) => null, (r) => r.first),
              equals(expectedResponse.first));
        },
      );

      test(
        'should not update returned pokemons if they are not in cache',
        () async {
          // arrange

          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tCachedPokemonNotInRemote);
          when(mockPokemonRemoteDataSource.getMorePokemons(
                  offset: anyNamed('offset')))
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getMorePokemons(offset: tOffset);

          // assert
          verify(mockPokemonRemoteDataSource.getMorePokemons(offset: tOffset));
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
          expect(result, equals(Right(tPokemons)));
        },
      );

      test(
        'should only contain cached favorite pokemons matching returned data',
        // * since we have already fetched them in the getInitial count
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async =>
                  [...tCachedFavoritePokemons, ...tCachedPokemonNotInRemote]);
          when(mockPokemonRemoteDataSource.getMorePokemons(
                  offset: anyNamed('offset')))
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getMorePokemons(offset: tOffset);

          // assert
          verify(mockPokemonRemoteDataSource.getMorePokemons(offset: tOffset));
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());

          final expected = result.fold((l) => null, (pokemons) => pokemons);

          expect(expected!.contains(tCachedPokemonNotInRemote.first), false);
        },
      );

      test(
        '''should throw, handle CacheException (by ignoring favorites pokemon check, as this should not affect remote pokemon)
        when no cached pokemon is available''',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenThrow(CacheException());
          when(mockPokemonRemoteDataSource.getMorePokemons(
                  offset: anyNamed('offset')))
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getMorePokemons(offset: tOffset);

          // assert
          verify(mockPokemonRemoteDataSource.getMorePokemons(offset: tOffset));
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
          expect(result, equals(Right(tPokemons)));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should not call remote data source when device is offline',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getInitialPokemons())
              .thenThrow(ServerException());

          // act
          await repository.getInitialPokeMons();

          // assert
          verifyZeroInteractions(mockPokemonRemoteDataSource);
        },
      );

      test(
        'should not check local data source device is offline',
        () async {
          // arrange

          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenThrow(CacheException());

          // act
          await repository.getInitialPokeMons();

          // assert
          verifyZeroInteractions(mockPokemonLocalDataSource);
        },
      );

      test(
        'should return DeviceOfflineFailure when device is offline',
        () async {
          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verifyZeroInteractions(mockPokemonRemoteDataSource);
          verifyZeroInteractions(mockPokemonLocalDataSource);
          expect(result, Left(DeviceOfflineFailure()));
        },
      );
    });
  });

  group('addPokemonToFavoritesLocal', () {
    const tPokemon = Pokemon(
      name: 'name',
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
    test(
      'should add pokemon to cache',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.cacheFavoritePokemon(any))
            .thenAnswer((_) async => SuccessEntity());

        // act
        await repository.addPokemonToFavoritesLocal(pokemon: tPokemon);

        // assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(
          mockPokemonLocalDataSource.cacheFavoritePokemon(
            PokemonModel.fromPokemon(tPokemon).copyWith(
              isFavorite: true,
            ),
          ),
        );
      },
    );

    test(
      'should return Success entity when caching is successful',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.cacheFavoritePokemon(any))
            .thenAnswer((_) async => SuccessEntity());

        // act
        final result =
            await repository.addPokemonToFavoritesLocal(pokemon: tPokemon);

        // assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource.cacheFavoritePokemon(
            PokemonModel.fromPokemon(tPokemon).copyWith(isFavorite: true)));
        expect(result, Right(SuccessEntity()));
      },
    );

    test(
      'should return a CacheFailure if any error occurs while caching',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.cacheFavoritePokemon(any))
            .thenThrow(CacheException());

        // act
        final result =
            await repository.addPokemonToFavoritesLocal(pokemon: tPokemon);

        // assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource.cacheFavoritePokemon(
            PokemonModel.fromPokemon(tPokemon).copyWith(isFavorite: true)));
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('removePokemonFromFavoritesLocal', () {
    const tPokemon = Pokemon(
      name: 'name',
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
    test(
      'should remove the pokemon from cache',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.removeFavoritePokemon(any))
            .thenAnswer((_) async => SuccessEntity());

        // act
        await repository.removePokemonFromFavoritesLocal(pokemon: tPokemon);

        // assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource
            .removeFavoritePokemon(PokemonModel.fromPokemon(tPokemon)));
      },
    );

    test(
      'should return a SuccessEntity when pokemon has been removed',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.removeFavoritePokemon(any))
            .thenAnswer((_) async => SuccessEntity());

        // act
        final result =
            await repository.removePokemonFromFavoritesLocal(pokemon: tPokemon);

        // assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource
            .removeFavoritePokemon(PokemonModel.fromPokemon(tPokemon)));
        expect(result, Right(SuccessEntity()));
      },
    );

    test(
      'should return a CacheFailure when any error occurs',
      () async {
        // arrange
        when(mockPokemonLocalDataSource.removeFavoritePokemon(any))
            .thenThrow(CacheException());

        // act
        final result =
            await repository.removePokemonFromFavoritesLocal(pokemon: tPokemon);

        // assert
        verifyZeroInteractions(mockPokemonRemoteDataSource);
        verify(mockPokemonLocalDataSource
            .removeFavoritePokemon(PokemonModel.fromPokemon(tPokemon)));
        expect(result, Left(CacheFailure()));
      },
    );
  });
}
