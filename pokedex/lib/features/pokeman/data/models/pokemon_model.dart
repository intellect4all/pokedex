import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';

import 'all_stats_model.dart';

class PokemonModel extends Pokemon {
  final String name;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final AllStatsModel stats;
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

  factory PokemonModel.fromJson(dynamic json) {
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

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'id': id,
      'name': name,
      'sprites': {
        "official-artwork": {"front_default": imageUrl}
      },
      'stats': stats.toJson(),
      'weight': weight,
      "types": getTypesJson(),
    };
  }

  List<Map<String, dynamic>> getTypesJson() {
    List<Map<String, dynamic>> returnedData = [];

    for (var type in types) {
      returnedData.add({
        "type": {
          "name": type,
        }
      });
    }

    return returnedData;
  }

  PokemonModel copyWith({
    String? name,
    int? id,
    int? height,
    int? weight,
    List<String>? types,
    AllStatsModel? stats,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return PokemonModel(
      name: name ?? this.name,
      id: id ?? this.id,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      types: types ?? this.types,
      stats: stats ?? this.stats,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory PokemonModel.fromPokemon(Pokemon pokemon) {
    return PokemonModel(
      name: pokemon.name,
      id: pokemon.id,
      height: pokemon.height,
      weight: pokemon.weight,
      types: pokemon.types,
      stats: AllStatsModel.fromEntity(pokemon.stats),
      imageUrl: pokemon.imageUrl,
      isFavorite: pokemon.isFavorite,
    );
  }
}
