import 'package:equatable/equatable.dart';

import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';

class Pokemon extends Equatable {
  final String name;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final AllStats stats;
  final String imageUrl;
  final bool isFavorite;
  const Pokemon({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.imageUrl,
    required this.isFavorite,
  });

  double get getBMI {
    return _calculateBMI(height: height, weight: weight);
  }

  double get getAveragePower => stats.getAveragePower;

  static double _calculateBMI({required int height, required int weight}) {
    try {
      if (height > 1 && weight > 1) {
        return (weight / (height * height));
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  @override
  List<Object?> get props =>
      [name, id, height, weight, types, stats, imageUrl, isFavorite];
}
