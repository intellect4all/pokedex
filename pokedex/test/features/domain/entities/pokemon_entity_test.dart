import 'package:mockito/mockito.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test pokemon entity', () {
    test(
      'should test a correct bmi [0.1] value for a pokemon with [height =10] and [weight =10]',
      () async {
        //Arrange
        final pokemon = Pokemon(
          name: 'name',
          id: 'id',
          height: 10,
          weight: 10,
          type: ['grass'],
          stats: _getTestStats(),
          imageUrl: 'imageUrl',
          isFavourite: false,
        );
        //Act
        final bmi = pokemon.getBMI;

        //Assert
        expect(bmi, 0.1);
      },
    );

    test(
      'should test that getBMI returns 0.0 when the height or width is zero ',
      () async {
        //Arrange
        final zeroHeightPokemon = Pokemon(
          name: 'name',
          id: 'id',
          height: 0,
          weight: 10,
          type: ['grass'],
          stats: _getTestStats(),
          imageUrl: 'imageUrl',
          isFavourite: false,
        );

        final zeroWeightPokemon = Pokemon(
          name: 'name',
          id: 'id',
          height: 20,
          weight: 0,
          type: ['grass'],
          stats: _getTestStats(),
          imageUrl: 'imageUrl',
          isFavourite: false,
        );
        //Act
        final zeroHeightPokemonBmi = zeroHeightPokemon.getBMI;
        final zeroWeightPokemonBmi = zeroWeightPokemon.getBMI;

        //Assert
        expect(zeroHeightPokemonBmi, 0.0);
        expect(zeroWeightPokemonBmi, 0.0);
      },
    );

    test(
      'should test that getAveragePower returns 2.0 when all stats are 2',
      () async {
        //Arrange
        final tPokemon = Pokemon(
          name: 'name',
          id: 'id',
          height: 0,
          weight: 10,
          type: ['grass'],
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
        );

        //Act
        final averagePower = tPokemon.getAveragePower;

        //Assert
        expect(averagePower, 2.0);
      },
    );
  });
}

_getTestStats() {
  return AllStats(
    attack: BaseStatType(name: '', value: 2),
    defense: BaseStatType(name: '', value: 2),
    specialAttack: BaseStatType(name: '', value: 2),
    specialDefense: BaseStatType(name: '', value: 2),
    speed: BaseStatType(name: '', value: 2),
    hp: BaseStatType(name: '', value: 2),
  );
}