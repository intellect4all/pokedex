import 'package:equatable/equatable.dart';

import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';

class AllStats extends Equatable {
  final BaseStatType hp;
  final BaseStatType attack;
  final BaseStatType defense;
  final BaseStatType specialAttack;
  final BaseStatType specialDefense;
  final BaseStatType speed;
  const AllStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  double get getAveragePower => ((hp.value +
          attack.value +
          defense.value +
          specialAttack.value +
          specialDefense.value +
          speed.value) /
      6);

  @override
  List<Object> get props {
    return [
      hp,
      attack,
      defense,
      specialAttack,
      specialDefense,
      speed,
    ];
  }
}
