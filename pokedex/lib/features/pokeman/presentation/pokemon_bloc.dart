import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex/core/constants/strings.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/domain/usecases/add_pokemon_to_favorites_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_initial_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_more_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/remove_pokemon_from_favorites_local_usecase.dart';
// import 'package:pokedex/features/pokeman/presentation/pokemon_helper.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetInitialPokemonsUseCase _getInitialPokemonsUseCase;
  final GetMorePokemonsUseCase _getMorePokemonsUseCase;
  final AddPokemonToFavoritesLocalUseCase _addPokemonToFavoritesLocalUseCase;
  final RemovePokemonFromFavoritesLocalUseCase
      _removePokemonFromFavoritesLocalUseCase;

  PokemonBloc({
    required GetInitialPokemonsUseCase getInitialPokemonsUseCase,
    required GetMorePokemonsUseCase getMorePokemonsUseCase,
    required AddPokemonToFavoritesLocalUseCase
        addPokemonToFavoritesLocalUseCase,
    required RemovePokemonFromFavoritesLocalUseCase
        removePokemonFromFavoritesLocalUseCase,
  })  : _getInitialPokemonsUseCase = getInitialPokemonsUseCase,
        _getMorePokemonsUseCase = getMorePokemonsUseCase,
        _addPokemonToFavoritesLocalUseCase = addPokemonToFavoritesLocalUseCase,
        _removePokemonFromFavoritesLocalUseCase =
            removePokemonFromFavoritesLocalUseCase,

        //pokemon helper
        super(PokemonInitialState()) {
    on<LoadInitialPokemonsEvent>(
        (event, emit) async => await _getInitialPokemons(event, emit));
    on<LoadMorePokemonsEvent>(
        (event, emit) async => await _getMorePokemons(event, emit));
    on<AddPokemonToFavoriteEvent>(
        (event, emit) async => await _addPokemonToFavorites(event, emit));
    on<RemovePokemonFromFavoriteEvent>(
        (event, emit) async => await _removePokemonFromFavorites(event, emit));
  }

  _getInitialPokemons(
    LoadInitialPokemonsEvent event,
    Emitter<PokemonState> emit,
  ) async {
    emit(LoadingPokemonsState());

    final failureOrPokemons = await _getInitialPokemonsUseCase(NoParams());
    failureOrPokemons.fold(
      (failure) => emit(
        const LoadInitialPokemonErrorState(
            message: LOAD_INITIAL_POKEMONS_FAILURE_MESSAGE),
      ),
      (pokemons) => emit(PokemonsLoadedState(pokemons: pokemons)),
    );
  }

  _getMorePokemons(
      LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    emit(LoadingPokemonsState());

    final failureOrPokemons = await _getMorePokemonsUseCase(
      LoadMorePokemonsParams(offset: event.offset),
    );

    failureOrPokemons.fold(
      (failure) => emit(
        const LoadMorePokemonErrorState(
            message: LOAD_MORE_POKEMONS_FAILURE_MESSAGE),
      ),
      (pokemons) => emit(PokemonsLoadedState(pokemons: pokemons)),
    );
  }

  _addPokemonToFavorites(
      AddPokemonToFavoriteEvent event, Emitter<PokemonState> emit) async {
    final failureOrSuccess = await _addPokemonToFavoritesLocalUseCase(
      AddToFavoritesParams(pokemon: event.pokemonToFavorite),
    );

    failureOrSuccess.fold(
      (failure) => emit(const FavoritePokemonsErrorState(
          message: ADD_TO_FAVORITES_ERROR_MESSAGE)),
      (success) {
        emit(PokemonAddedToFavoriteState(
          pokemon: event.pokemonToFavorite,
        ));
      },
    );
  }

  _removePokemonFromFavorites(
      RemovePokemonFromFavoriteEvent event, Emitter<PokemonState> emit) async {
    final failureOrSuccess = await _removePokemonFromFavoritesLocalUseCase(
      RemovePokemonFromFavoritesLocalParams(pokemon: event.pokemon),
    );

    failureOrSuccess.fold(
      (failure) => emit(const FavoritePokemonsErrorState(
          message: REMOVE_FROM_FAVORITES_ERROR_MESSAGE)),
      (success) {
        emit(
          PokemonRemovedFromFavoriteState(
            pokemon: event.pokemon,
          ),
        );
      },
    );
  }
}
