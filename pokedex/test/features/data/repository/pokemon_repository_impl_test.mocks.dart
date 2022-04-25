// Mocks generated by Mockito 5.1.0 from annotations
// in pokedex/test/features/data/repository/pokemon_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pokedex/core/utils/network_info.dart' as _i7;
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_local_data_source.dart'
    as _i6;
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_remote_data_source.dart'
    as _i3;
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart' as _i5;
import 'package:pokedex/features/pokeman/domain/entities/success_entity.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeSuccessEntity_0 extends _i1.Fake implements _i2.SuccessEntity {}

/// A class which mocks [PokemonRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPokemonRemoteDataSource extends _i1.Mock
    implements _i3.PokemonRemoteDataSource {
  MockPokemonRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i5.PokemonModel>> getInitialPokemons() =>
      (super.noSuchMethod(Invocation.method(#getInitialPokemons, []),
              returnValue:
                  Future<List<_i5.PokemonModel>>.value(<_i5.PokemonModel>[]))
          as _i4.Future<List<_i5.PokemonModel>>);
  @override
  _i4.Future<List<_i5.PokemonModel>> getMorePokemons({int? offset}) => (super
      .noSuchMethod(Invocation.method(#getMorePokemons, [], {#offset: offset}),
          returnValue:
              Future<List<_i5.PokemonModel>>.value(<_i5.PokemonModel>[])) as _i4
      .Future<List<_i5.PokemonModel>>);
}

/// A class which mocks [PokemonLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPokemonLocalDataSource extends _i1.Mock
    implements _i6.PokemonLocalDataSource {
  MockPokemonLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i5.PokemonModel>> getCachedFavoritePokemons() =>
      (super.noSuchMethod(Invocation.method(#getCachedFavoritePokemons, []),
              returnValue:
                  Future<List<_i5.PokemonModel>>.value(<_i5.PokemonModel>[]))
          as _i4.Future<List<_i5.PokemonModel>>);
  @override
  _i4.Future<_i2.SuccessEntity> cacheFavoritePokemon(
          _i5.PokemonModel? pokemonToCache) =>
      (super.noSuchMethod(
              Invocation.method(#cacheFavoritePokemon, [pokemonToCache]),
              returnValue:
                  Future<_i2.SuccessEntity>.value(_FakeSuccessEntity_0()))
          as _i4.Future<_i2.SuccessEntity>);
  @override
  _i4.Future<_i2.SuccessEntity> removeFavoritePokemon(
          _i5.PokemonModel? pokemonToBeRemoved) =>
      (super.noSuchMethod(
              Invocation.method(#removeFavoritePokemon, [pokemonToBeRemoved]),
              returnValue:
                  Future<_i2.SuccessEntity>.value(_FakeSuccessEntity_0()))
          as _i4.Future<_i2.SuccessEntity>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i7.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
}
