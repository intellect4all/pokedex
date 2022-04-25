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
  final List<Pokemon> currentPokemons;
  const AddPokemonToFavoriteEvent({
    required this.pokemonToFavorite,
    required this.currentPokemons,
  });

  @override
  List<Object> get props => [pokemonToFavorite, currentPokemons];
}

class RemovePokemonFromFavoriteEvent extends PokemonEvent {
  final Pokemon pokemon;
  final List<Pokemon> currentPokemons;
  const RemovePokemonFromFavoriteEvent({
    required this.pokemon,
    required this.currentPokemons,
  });

  @override
  List<Object> get props => [pokemon, currentPokemons];
}
