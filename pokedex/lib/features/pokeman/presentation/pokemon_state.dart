part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class PokemonInitialState extends PokemonState {}

class LoadingPokemonsState extends PokemonState {}

class PokemonsLoadedState extends PokemonState {
  final List<Pokemon> pokemons;

  const PokemonsLoadedState({
    required this.pokemons,
  });

  @override
  List<Object> get props => [pokemons];
}

class LoadMorePokemonErrorState extends PokemonState {
  final String message;
  const LoadMorePokemonErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class LoadInitialPokemonErrorState extends PokemonState {
  final String message;
  const LoadInitialPokemonErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class PokemonAddedToFavoriteState extends PokemonState {
  final Pokemon pokemon;
  final List<Pokemon> newPokemons;
  const PokemonAddedToFavoriteState({
    required this.pokemon,
    required this.newPokemons,
  });

  @override
  List<Object> get props => [pokemon, newPokemons];
}

class PokemonRemovedFromFavoriteState extends PokemonState {
  final Pokemon pokemon;
  final List<Pokemon> newPokemons;
  const PokemonRemovedFromFavoriteState({
    required this.pokemon,
    required this.newPokemons,
  });

  @override
  List<Object> get props => [pokemon, newPokemons];
}

class FavoritePokemonsErrorState extends PokemonState {
  final String message;
  const FavoritePokemonsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
