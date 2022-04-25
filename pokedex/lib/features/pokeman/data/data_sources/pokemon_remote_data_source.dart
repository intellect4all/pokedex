import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/core/constants/api_endpoints.dart';
import 'package:pokedex/core/errors/exceptions.dart';

import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// calls https://pokeapi.co/api/v2/pokemon for the initial list of pokemons
  ///
  /// then calls the returned [url] to fetch pokemon details
  /// pokemon details for each returned data
  ///
  /// throws a [ServerException] for all failed responses
  Future<List<PokemonModel>> getInitialPokemons();

  /// calls https://pokeapi.co/api/v2/pokemon?limit=[FETCH_LIMIT]&offset=[offset] for the fetch paginated list of pokemons
  ///
  /// then calls the returned [url] to fetch pokemon details
  /// pokemon details for each returned data
  ///
  /// [FETCH_LIMIT] is 20 by default
  ///
  /// throws a [ServerException] for failed responses
  Future<List<PokemonModel>> getMorePokemons({
    required int offset,
  });
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;
  final JsonCodec jsonCodec;
  PokemonRemoteDataSourceImpl({
    required this.client,
    required this.jsonCodec,
  });

  @override
  Future<List<PokemonModel>> getInitialPokemons() async {
    List<PokemonModel> pokemons = [];
    final responseFromListPokemons = await client.get(
      Uri.parse(LIST_POKEMONS_ENDPOINT),
      headers: {'Content-Type': 'application/json'},
    );

    if (responseFromListPokemons.statusCode == 200) {
      final response = jsonCodec.decode(responseFromListPokemons.body);
      final pokemonsListJson = response['results'];
      for (var pokemon in pokemonsListJson) {
        final pokemonDetailsResponse = await client.get(
          Uri.parse(pokemon['url']),
          headers: {'Content-Type': 'application/json'},
        );
        if (pokemonDetailsResponse.statusCode == 200) {
          final pokemonDetailsJsonMap =
              jsonCodec.decode(pokemonDetailsResponse.body);
          pokemons.add(PokemonModel.fromJson(pokemonDetailsJsonMap));
        } else {
          throw ServerException();
        }
      }
      return pokemons;
    } else {
      log(responseFromListPokemons.body.toString());
      log(responseFromListPokemons.statusCode.toString());
      debugPrint(responseFromListPokemons.body.toString());
      debugPrint(responseFromListPokemons.statusCode.toString());
      throw ServerException();
    }
  }

  @override
  Future<List<PokemonModel>> getMorePokemons({required int offset}) async {
    List<PokemonModel> pokemons = [];
    final responseFromListPokemons = await client.get(
      Uri.parse(LIST_POKEMONS_ENDPOINT + '&offset=$offset'),
      headers: {'Content-Type': 'application/json'},
    );

    if (responseFromListPokemons.statusCode == 200) {
      final response = jsonCodec.decode(responseFromListPokemons.body);
      final pokemonsListJson = response['results'];
      for (var pokemon in pokemonsListJson) {
        final pokemonDetailsResponse = await client.get(
          Uri.parse(pokemon['url']),
          headers: {'Content-Type': 'application/json'},
        );
        if (pokemonDetailsResponse.statusCode == 200) {
          final pokemonDetailsJsonMap =
              jsonCodec.decode(pokemonDetailsResponse.body);
          pokemons.add(PokemonModel.fromJson(pokemonDetailsJsonMap));
        } else {
          throw ServerException();
        }
      }
      return pokemons;
    } else {
      log(responseFromListPokemons.body.toString());
      log(responseFromListPokemons.statusCode.toString());
      debugPrint(responseFromListPokemons.body.toString());
      debugPrint(responseFromListPokemons.statusCode.toString());
      throw ServerException();
    }
  }
}
