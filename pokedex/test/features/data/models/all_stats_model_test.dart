import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokeman/data/models/all_stats_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tAllStatsModel = AllStatsModel(
    modelAttack: BaseStatType(name: 'attack', value: 49),
    modelDefense: BaseStatType(name: 'defense', value: 49),
    modelSpecialAttack: BaseStatType(name: 'special-attack', value: 65),
    modelSpecialDefense: BaseStatType(name: 'special-defense', value: 65),
    modelSpeed: BaseStatType(name: 'speed', value: 45),
    modelHp: BaseStatType(name: 'hp', value: 45),
  );

  test(
    'should test that AllStatsModel is a subclass of AllStats',
    () async {
      expect(tAllStatsModel, isA<AllStats>());
    },
  );
  group('fromJson', () {
    test(
      'should return an AllStatsModel object when valid json is passed',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pokemon.json'));

        // act
        final result = AllStatsModel.fromJson(jsonMap['stats']);

        // assert
        expect(result, tAllStatsModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return an JsonMap containing valid data',
      () async {
        // act
        final result = tAllStatsModel.toJson();

        final expectedList = [
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
        ];

        // assert
        expect(result, expectedList);
      },
    );
  });

  group('toEntity', () {
    const tAllStats = AllStats(
      attack: BaseStatType(name: 'attack', value: 49),
      defense: BaseStatType(name: 'defense', value: 49),
      specialAttack: BaseStatType(name: 'special-attack', value: 65),
      specialDefense: BaseStatType(name: 'special-defense', value: 65),
      speed: BaseStatType(name: 'speed', value: 45),
      hp: BaseStatType(name: 'hp', value: 45),
    );
    test(
      'should return a AllStatModel from AllStats entity',
      () async {
        // act
        final result = AllStatsModel.fromEntity(tAllStats);

        // assert
        expect(result, tAllStatsModel);
      },
    );
  });
}
