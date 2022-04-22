import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';

import 'all_stats_model.dart';

class PokemonModel extends Pokemon {
  final String name;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final AllStats stats;
  final String imageUrl;
  final bool isFavorite;
  const PokemonModel({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.imageUrl,
    required this.isFavorite,
  }) : super(
          height: height,
          weight: weight,
          name: name,
          id: id,
          imageUrl: imageUrl,
          stats: stats,
          isFavorite: isFavorite,
          types: types,
        );

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      id: json['id'],
      height: json['height'],
      weight: json['weight'],
      types: getTypesFromMap(json['types'] ?? []),
      stats: AllStatsModel.fromJson(json['stats']),
      imageUrl: getImageUrlFromMap(json['sprites']),
      isFavorite: false,
    );
  }

  static List<String> getTypesFromMap(List<dynamic> rawTypes) {
    List<String> types = [];

    for (var type in rawTypes) {
      types.add(type['type']['name']);
    }
    return types;
  }

  static String getImageUrlFromMap(Map<String, dynamic> rawData) {
    return rawData['other']?['official-artwork']?['front_default']
            ?.toString() ??
        '';
  }
}
