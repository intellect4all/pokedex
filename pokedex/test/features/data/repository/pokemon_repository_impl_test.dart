import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/core/errors/failure.dart';
import 'package:pokedex/features/pokeman/data/models/all_stats_model.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/data/repositories/pokemon_repository_implementation.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';

import '../../../core/utils/network_info/fake_network_info.dart';
import '../data_sources/fake_pokemon_local_data_source.dart';
import '../data_sources/fake_pokemon_remote_data_source.dart';
import 'pokemon_repository_impl_test.mocks.dart';

@GenerateMocks(
    [FakePokemonRemoteDataSource, FakePokemonLocalDataSource, FakeNetworkInfo])
void main() {
  late MockFakeNetworkInfo mockNetworkInfo;
  late MockFakePokemonLocalDataSource mockPokemonLocalDataSource;
  late MockFakePokemonRemoteDataSource mockPokemonRemoteDataSource;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockNetworkInfo = MockFakeNetworkInfo();
    mockPokemonLocalDataSource = MockFakePokemonLocalDataSource();
    mockPokemonRemoteDataSource = MockFakePokemonRemoteDataSource();
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
      when(mockPokemonRemoteDataSource.getInitialPokeMans())
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
              .thenAnswer((_) async => tPokemonModels);
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => []);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
          expect(result, equals(Right(tPokemons)));
        },
      );
      test(
        'should return a server failure when the pokemons could not be fetched',
        () async {
          // arrange
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
              .thenThrow(ServerException());

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
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
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
          verify(mockPokemonLocalDataSource.getCachedFavoritePokemons());
        },
      );

      test(
        'should update favorite pokemons from the returned remote pokemons',
        () async {
          // arrange
          when(mockPokemonLocalDataSource.getCachedFavoritePokemons())
              .thenAnswer((_) async => tCachedFavoritePokemons);
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
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

          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
              .thenAnswer((_) async => tPokemonModels);

          // act
          final result = await repository.getInitialPokeMons();

          // assert
          verify(mockPokemonRemoteDataSource.getInitialPokeMans());
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
              .thenAnswer((_) async => tPokemonModels);

          // act
          await repository.getMorePokemons(offset: tOffset);

          // assert
          verifyNever(mockPokemonRemoteDataSource.getInitialPokeMans());
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
          when(mockPokemonRemoteDataSource.getInitialPokeMans())
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
}
