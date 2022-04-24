import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';

class AllStatsModel extends AllStats {
  final BaseStatType modelHp;
  final BaseStatType modelAttack;
  final BaseStatType modelDefense;
  final BaseStatType modelSpecialAttack;
  final BaseStatType modelSpecialDefense;
  final BaseStatType modelSpeed;
  const AllStatsModel({
    required this.modelHp,
    required this.modelAttack,
    required this.modelDefense,
    required this.modelSpecialAttack,
    required this.modelSpecialDefense,
    required this.modelSpeed,
  }) : super(
          attack: modelAttack,
          hp: modelHp,
          defense: modelDefense,
          specialAttack: modelSpecialAttack,
          specialDefense: modelSpecialDefense,
          speed: modelSpeed,
        );

  AllStatsModel copyWith({
    BaseStatType? modelHp,
    BaseStatType? modelAttack,
    BaseStatType? modelDefense,
    BaseStatType? modelSpecialAttack,
    BaseStatType? modelSpecialDefense,
    BaseStatType? modelSpeed,
  }) {
    return AllStatsModel(
      modelHp: modelHp ?? this.modelHp,
      modelAttack: modelAttack ?? this.modelAttack,
      modelDefense: modelDefense ?? this.modelDefense,
      modelSpecialAttack: modelSpecialAttack ?? this.modelSpecialAttack,
      modelSpecialDefense: modelSpecialDefense ?? this.modelSpecialDefense,
      modelSpeed: modelSpeed ?? this.modelSpeed,
    );
  }

  factory AllStatsModel.fromJson(List<dynamic> json) {
    Map<String, BaseStatType> baseStats = {};
    for (var data in json) {
      final name = data['stat']['name'];
      baseStats[name] = BaseStatType(name: name, value: data['base_stat']);
    }

    return AllStatsModel(
      modelHp: baseStats['hp'] ?? const BaseStatType(name: 'hp', value: 0),
      modelAttack:
          baseStats['attack'] ?? const BaseStatType(name: 'attack', value: 0),
      modelDefense:
          baseStats['defense'] ?? const BaseStatType(name: 'defense', value: 0),
      modelSpecialAttack: baseStats['special-attack'] ??
          const BaseStatType(name: 'specialAttack', value: 0),
      modelSpecialDefense: baseStats['special-defense'] ??
          const BaseStatType(name: 'special-defense', value: 0),
      modelSpeed:
          baseStats['speed'] ?? const BaseStatType(name: 'speed', value: 0),
    );
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> list = [];
    list.add(modelHp.toMap());
    list.add(modelAttack.toMap());
    list.add(modelDefense.toMap());
    list.add(modelSpecialAttack.toMap());
    list.add(modelSpecialDefense.toMap());
    list.add(modelSpeed.toMap());
    return list;
  }

  factory AllStatsModel.fromEntity(AllStats stats) {
    return AllStatsModel(
      modelHp: stats.hp,
      modelAttack: stats.attack,
      modelDefense: stats.defense,
      modelSpecialAttack: stats.specialAttack,
      modelSpecialDefense: stats.specialDefense,
      modelSpeed: stats.speed,
    );
  }
}
