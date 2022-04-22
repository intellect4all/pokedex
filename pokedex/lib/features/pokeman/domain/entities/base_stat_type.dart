import 'package:equatable/equatable.dart';

class BaseStatType extends Equatable {
  final String name;
  final int value;
  const BaseStatType({
    required this.name,
    required this.value,
  });

  @override
  List<Object> get props => [name, value];
}
