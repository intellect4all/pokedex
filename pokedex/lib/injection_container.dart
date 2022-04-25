import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pokedex/core/constants/keys.dart';
import 'package:pokedex/core/utils/network_info/network_info.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokeman/data/repositories/pokemon_repository_implementation.dart';
import 'package:pokedex/features/pokeman/domain/repository/pokemon_repository.dart';
import 'package:pokedex/features/pokeman/domain/usecases/add_pokemon_to_favorites_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_initial_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/get_more_pokemons_usecase.dart';
import 'package:pokedex/features/pokeman/domain/usecases/remove_pokemon_from_favorites_local_usecase.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_helper.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Feature initialization here
  sl.registerFactory(
    () => PokemonBloc(
      getInitialPokemonsUseCase: sl(),
      getMorePokemonsUseCase: sl(),
      addPokemonToFavoritesLocalUseCase: sl(),
      removePokemonFromFavoritesLocalUseCase: sl(),
      pokemonHelper: sl(),
    ),
  );

  //! UseCases
  sl.registerLazySingleton(() => GetInitialPokemonsUseCase(sl()));
  sl.registerLazySingleton(() => GetMorePokemonsUseCase(sl()));
  sl.registerLazySingleton(() => AddPokemonToFavoritesLocalUseCase(sl()));
  sl.registerLazySingleton(() => RemovePokemonFromFavoritesLocalUseCase(sl()));

  //! core
  sl.registerLazySingleton(() => PokemonHelper());

  //! Repository
  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      networkInfo: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  //! Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(
      jsonCodec: sl(),
      client: sl(),
    ),
  );

  sl.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(
      hiveBoxes: sl(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External dependencies
  await Hive.initFlutter();
  final box = await Hive.openBox(POKEMON_HIVE_BOX);
  sl.registerLazySingleton(() => HiveBoxes(favouritePokemonBox: box));

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const JsonCodec());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
