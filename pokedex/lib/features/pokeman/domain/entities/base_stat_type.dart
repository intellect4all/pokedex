import 'package:equatable/equatable.dart';

class BaseStatType extends Equatable {
  final String name;
  final int value;
  const BaseStatType({
    required this.name,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'base_stat': value,
      'stat': {
        'name': name,
      }
    };
  }

  @override
  List<Object> get props => [name, value];
}
