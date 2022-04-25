import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex/features/pokeman/data/models/all_stats_model.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_helper.dart';

void main() {
  late PokemonHelper pokemonHelper;

  setUp(() {
    pokemonHelper = PokemonHelper();
  });

  const tPokemon = Pokemon(
    name: 'name 1',
    id: 1,
    height: 0,
    weight: 10,
    types: ['grass'],
    stats: AllStats(
      attack: BaseStatType(name: 'attack', value: 2),
      defense: BaseStatType(name: 'defense', value: 2),
      specialAttack: BaseStatType(name: 'special-attack', value: 2),
      specialDefense: BaseStatType(name: 'special-defense', value: 2),
      speed: BaseStatType(name: 'speed', value: 2),
      hp: BaseStatType(name: 'hp', value: 2),
    ),
    imageUrl: 'imageUrl',
    isFavorite: false,
  );

  group('changePokemonFavoriteState', () {
    test(
      'should return an empty list if the list of pokemon is empty',
      () async {
        // act
        final result = pokemonHelper.changePokemonFavoriteState(
          pokemon: tPokemon,
          isFavorite: true,
          pokemons: [],
        );

        // assert
        expect(result, []);
      },
    );

    test(
      'should return a list of pokemons with the updated pokemon data if the pokemon list contains the pokemon',
      () async {
        // act
        final result = pokemonHelper.changePokemonFavoriteState(
          pokemon: tPokemon,
          isFavorite: true,
          pokemons: tPokemons,
        );

        // assert
        expect(result, expectedPokemons);
      },
    );
    test(
      'should return the same list of pokemon as passed if the pokemon list does not contain the pokemon',
      () async {
        // act
        final result = pokemonHelper.changePokemonFavoriteState(
          pokemon: const Pokemon(
            name: 'name 1',
            id: 5,
            height: 0,
            weight: 10,
            types: ['grass'],
            stats: AllStats(
              attack: BaseStatType(name: 'attack', value: 2),
              defense: BaseStatType(name: 'defense', value: 2),
              specialAttack: BaseStatType(name: 'special-attack', value: 2),
              specialDefense: BaseStatType(name: 'special-defense', value: 2),
              speed: BaseStatType(name: 'speed', value: 2),
              hp: BaseStatType(name: 'hp', value: 2),
            ),
            imageUrl: 'imageUrl',
            isFavorite: false,
          ),
          isFavorite: true,
          pokemons: tPokemons,
        );

        // assert
        expect(result, tPokemons);
      },
    );
  });
}

List<Pokemon> get expectedPokemons => [
      const PokemonModel(
        name: 'name 1',
        id: 1,
        height: 0,
        weight: 10,
        types: ['grass'],
        stats: AllStatsModel(
          modelAttack: BaseStatType(name: 'attack', value: 2),
          modelDefense: BaseStatType(name: 'defense', value: 2),
          modelSpecialAttack: BaseStatType(name: 'special-attack', value: 2),
          modelSpecialDefense: BaseStatType(name: 'special-defense', value: 2),
          modelSpeed: BaseStatType(name: 'speed', value: 2),
          modelHp: BaseStatType(name: 'hp', value: 2),
        ),
        imageUrl: 'imageUrl',
        isFavorite:
            true, // * note that isFavorite should now be changed to true
      ),
      const Pokemon(
        name: 'name 2',
        id: 2,
        height: 0,
        weight: 10,
        types: ['grass'],
        stats: AllStats(
          attack: BaseStatType(name: 'attack', value: 2),
          defense: BaseStatType(name: 'defense', value: 2),
          specialAttack: BaseStatType(name: 'special-attack', value: 2),
          specialDefense: BaseStatType(name: 'special-defense', value: 2),
          speed: BaseStatType(name: 'speed', value: 2),
          hp: BaseStatType(name: 'hp', value: 2),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      )
    ];

List<Pokemon> get tPokemons => [
      const Pokemon(
        name: 'name 1',
        id: 1,
        height: 0,
        weight: 10,
        types: ['grass'],
        stats: AllStats(
          attack: BaseStatType(name: 'attack', value: 2),
          defense: BaseStatType(name: 'defense', value: 2),
          specialAttack: BaseStatType(name: 'special-attack', value: 2),
          specialDefense: BaseStatType(name: 'special-defense', value: 2),
          speed: BaseStatType(name: 'speed', value: 2),
          hp: BaseStatType(name: 'hp', value: 2),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      ),
      const Pokemon(
        name: 'name 2',
        id: 2,
        height: 0,
        weight: 10,
        types: ['grass'],
        stats: AllStats(
          attack: BaseStatType(name: 'attack', value: 2),
          defense: BaseStatType(name: 'defense', value: 2),
          specialAttack: BaseStatType(name: 'special-attack', value: 2),
          specialDefense: BaseStatType(name: 'special-defense', value: 2),
          speed: BaseStatType(name: 'speed', value: 2),
          hp: BaseStatType(name: 'hp', value: 2),
        ),
        imageUrl: 'imageUrl',
        isFavorite: false,
      )
    ];
