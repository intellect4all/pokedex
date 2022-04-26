import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';

void main() {
  test('should test that getAveragePower returns 2.0 when all stats are 2',
      () async {
    //Arrange
    const tStats = AllStats(
      attack: BaseStatType(name: 'attack', value: 2),
      defense: BaseStatType(name: 'defense', value: 2),
      specialAttack: BaseStatType(name: 'specialAttack', value: 2),
      specialDefense: BaseStatType(name: 'specialDefense', value: 2),
      speed: BaseStatType(name: 'speed', value: 2),
      hp: BaseStatType(name: 'hp', value: 2),
    );

    //Act
    final averagePower = tStats.getAveragePower;

    //Assert
    expect(averagePower, 2.0);
  });
}
