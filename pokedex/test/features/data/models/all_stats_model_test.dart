import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokeman/data/models/all_stats_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tAllStats = AllStatsModel(
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
      expect(tAllStats, isA<AllStats>());
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
        expect(result, tAllStats);
      },
    );
  });
}
