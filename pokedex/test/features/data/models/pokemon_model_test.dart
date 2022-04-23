import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokeman/data/models/all_stats_model.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tPokemonModel = PokemonModel(
    name: 'bulbasaur',
    id: 1,
    height: 7,
    weight: 69,
    types: ['grass', 'poison'],
    stats: AllStatsModel(
      modelAttack: BaseStatType(name: 'attack', value: 49),
      modelDefense: BaseStatType(name: 'defense', value: 49),
      modelSpecialAttack: BaseStatType(name: 'special-attack', value: 65),
      modelSpecialDefense: BaseStatType(name: 'special-defense', value: 65),
      modelSpeed: BaseStatType(name: 'speed', value: 45),
      modelHp: BaseStatType(name: 'hp', value: 45),
    ),
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    isFavorite: false,
  );

  test(
    'should test that PokemonModel is a subclass of Pokemon',
    () async {
      // assert
      expect(tPokemonModel, isA<Pokemon>());
    },
  );

  group('class helpers', () {
    test(
      'should return a [String] when valid json is passed getImageUrl',
      () async {
        // arrange
        final Map<String, dynamic> rawJsonMap = json.decode(
          fixture('pokemon.json'),
        );

        // act
        final result = PokemonModel.getImageUrlFromMap(rawJsonMap['sprites']);

        // assert
        expect(result, tPokemonModel.imageUrl);
      },
    );

    test(
      'should return an empty string when invalid json is passed to getImageUrl',
      () async {
        // arrange
        final Map<String, dynamic> rawJsonMap = json.decode(
          fixture('invalid_pokemon.json'),
        );

        // act
        final result = PokemonModel.getImageUrlFromMap(rawJsonMap['sprites']);

        // assert
        expect(result, '');
      },
    );

    test(
      'should return a list of string when valid json is passed to getTypesFromMap',
      () async {
        // arrange
        final rawJsonMap = json.decode(
          fixture('pokemon.json'),
        );

        // act
        final result = PokemonModel.getTypesFromMap(rawJsonMap['types']);

        // assert
        expect(result, tPokemonModel.types);
      },
    );

    test(
      'should return an empty list when an invalid json is passed to getTypesFromMap',
      () async {
        // arrange
        final rawJsonMap = json.decode(
          fixture('invalid_pokemon.json'),
        );

        // act
        final result = PokemonModel.getTypesFromMap(rawJsonMap['types'] ?? []);

        // assert
        expect(result, []);
      },
    );
  });

  group('fromJson', () {
    test(
      'should return a valid Pokemon object when valid json data is passed',
      () async {
        // arrange
        final Map<String, dynamic> rawJsonMap = json.decode(
          fixture('pokemon.json'),
        );

        // act
        final result = PokemonModel.fromJson(rawJsonMap);

        // assert
        expect(result, tPokemonModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a valid JSON valid containing proper data',
      () async {
        final tJSONMap = {
          "height": 7,
          "id": 1,
          "name": "bulbasaur",
          "sprites": {
            "official-artwork": {
              "front_default":
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
            }
          },
          "stats": [
            {
              "base_stat": 45,
              "stat": {
                "name": "hp",
              }
            },
            {
              "base_stat": 49,
              "stat": {
                "name": "attack",
              }
            },
            {
              "base_stat": 49,
              "stat": {
                "name": "defense",
              }
            },
            {
              "base_stat": 65,
              "stat": {
                "name": "special-attack",
              }
            },
            {
              "base_stat": 65,
              "stat": {
                "name": "special-defense",
              }
            },
            {
              "base_stat": 45,
              "stat": {
                "name": "speed",
              }
            }
          ],
          "types": [
            {
              "type": {
                "name": "grass",
              }
            },
            {
              "type": {
                "name": "poison",
              }
            }
          ],
          "weight": 69
        };
        // act
        final result = tPokemonModel.toJson();

        // assert
        expect(result, tJSONMap);
      },
    );
  });
}
