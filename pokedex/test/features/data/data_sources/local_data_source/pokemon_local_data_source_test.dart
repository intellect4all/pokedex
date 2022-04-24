import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/constants/keys.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'pokemon_local_data_source_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  late PokemonLocalDataSourceImpl localDataSource;
  late MockBox mockFavoritePokemonBox;

  setUp(() {
    mockFavoritePokemonBox = MockBox();
    final hiveBoxes = HiveBoxes(favouritePokemonBox: mockFavoritePokemonBox);
    localDataSource = PokemonLocalDataSourceImpl(hiveBoxes: hiveBoxes);
  });

  group('getCachedFavoritePokemons', () {
    final List<dynamic> jsonMap = json.decode(fixture('cached_pokemons.json'));
    final tCachedPokemons =
        List.generate(3, (index) => PokemonModel.fromJson(jsonMap[index]));

    test(
      'should check if the cached pokemon box is open',
      () async {
        // arrange
        when(mockFavoritePokemonBox.isOpen).thenReturn(true);
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(true);
        // act
        await localDataSource.getCachedFavoritePokemons();

        // assert
        verify(mockFavoritePokemonBox.isOpen);
      },
    );

    test(
      'should throw a CacheException if box is not open',
      () async {
        // arrange
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isOpen).thenReturn(false);
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(true);

        // act
        callGetCached() async =>
            await localDataSource.getCachedFavoritePokemons();

        // assert

        expect(callGetCached, throwsA(isA<CacheException>()));
        verify(mockFavoritePokemonBox.isOpen);
      },
    );
    test(
      'should read the box values for cached data',
      () async {
        // arrange
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isOpen).thenReturn(true);
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(true);

        // act
        await localDataSource.getCachedFavoritePokemons();

        // assert
        verify(mockFavoritePokemonBox.values);
      },
    );

    test(
      'should check if the box is empty',
      () async {
        // arrange
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isOpen).thenReturn(true);
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(true);

        // act
        await localDataSource.getCachedFavoritePokemons();

        // assert
        verify(mockFavoritePokemonBox.values);
        verify(mockFavoritePokemonBox.isNotEmpty);
      },
    );

    test(
      'should returned a list of pokemons if cache is not empty',
      () async {
        // arrange
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isOpen).thenReturn(true);
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(true);

        // act
        final result = await localDataSource.getCachedFavoritePokemons();

        // assert
        verify(mockFavoritePokemonBox.values);
        verify(mockFavoritePokemonBox.isNotEmpty);
        expect(result, tCachedPokemons);
      },
    );

    test(
      'should throw a CacheException if box is empty',
      () async {
        // arrange
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isOpen).thenReturn(true);
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(false);

        // act
        callGetCached() async =>
            await localDataSource.getCachedFavoritePokemons();

        // assert
        expect(callGetCached, throwsA(isA<CacheException>()));
        verify(mockFavoritePokemonBox.isNotEmpty);
      },
    );

    test(
      'should throw a CacheException if any error occurs during caching',
      () async {
        // arrange
        when(mockFavoritePokemonBox.values).thenReturn(jsonMap);
        when(mockFavoritePokemonBox.isOpen).thenThrow(Exception());
        when(mockFavoritePokemonBox.isNotEmpty).thenReturn(false);

        // act
        callGetCached() async =>
            await localDataSource.getCachedFavoritePokemons();

        // assert
        expect(callGetCached, throwsA(isA<CacheException>()));
      },
    );
  });
}
