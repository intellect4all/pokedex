part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialPokemonsEvent extends PokemonEvent {}

class LoadMorePokemonsEvent extends PokemonEvent {
  final int offset;
  const LoadMorePokemonsEvent({
    required this.offset,
  });

  @override
  List<Object> get props => [offset];
}

class AddPokemonToFavoriteEvent extends PokemonEvent {
  final Pokemon pokemonToFavorite;

  const AddPokemonToFavoriteEvent({
    required this.pokemonToFavorite,
  });

  @override
  List<Object> get props => [pokemonToFavorite];
}

class RemovePokemonFromFavoriteEvent extends PokemonEvent {
  final Pokemon pokemon;

  const RemovePokemonFromFavoriteEvent({
    required this.pokemon,
  });

  @override
  List<Object> get props => [pokemon];
}
