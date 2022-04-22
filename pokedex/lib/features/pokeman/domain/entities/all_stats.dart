import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';

class AllStats {
  final BaseStatType hp;
  final BaseStatType attack;
  final BaseStatType defense;
  final BaseStatType specialAttack;
  final BaseStatType specialDefense;
  final BaseStatType speed;
  AllStats({
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
}
