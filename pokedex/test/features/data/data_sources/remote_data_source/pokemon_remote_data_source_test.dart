import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:pokedex/core/constants/api_endpoints.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/features/pokeman/data/data_sources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokeman/data/models/pokemon_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'pokemon_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client, JsonCodec])
void main() {
  late PokemonRemoteDataSourceImpl remoteDataSource;
  late MockClient mockHttpClient;
  late MockJsonCodec jsonCodec;

  setUp(() {
    mockHttpClient = MockClient();
    jsonCodec = MockJsonCodec();
    remoteDataSource = PokemonRemoteDataSourceImpl(
        client: mockHttpClient, jsonCodec: jsonCodec);
  });
  final rawPokemonsListJsonString = fixture('list_pokemons.json');
  final rawMorePokemonsListJsonString = fixture('list_more_pokemons.json');
  final decodedReturnedPokemonsList = _getDecodedPokemonsList();
  final tPokemonMaps = _getTestPokemonJsonMaps();
  final firstPokemonJsonString = jsonEncode(tPokemonMaps[0]);
  final secondPokemonJsonString = jsonEncode(tPokemonMaps[1]);
  final thirdPokemonJsonString = jsonEncode(tPokemonMaps[2]);
  final fourthPokemonJsonString = jsonEncode(tPokemonMaps[3]);

  setUpMockHttpPokemonDetailsSuccessResponse({
    required List<dynamic> decodedReturnedPokemonsList,
    required String firstPokemonJsonString,
    required String secondPokemonJsonString,
  }) {
    //stub for get request for first pokemon
    when(mockHttpClient.get(Uri.parse(decodedReturnedPokemonsList[0]['url']),
            headers: anyNamed('headers')))
        .thenAnswer(
      (_) async => http.Response(firstPokemonJsonString, 200),
    );

    //stub for get request for second pokemon
    when(mockHttpClient.get(Uri.parse(decodedReturnedPokemonsList[1]['url']),
            headers: anyNamed('headers')))
        .thenAnswer(
      (_) async => http.Response(secondPokemonJsonString, 200),
    );
  }

  setUpMockHttpPokemonDetailsFailureResponse({
    required List<dynamic> decodedReturnedPokemonsList,
    required String firstPokemonJsonString,
    required String secondPokemonJsonString,
  }) {
    when(mockHttpClient.get(Uri.parse(decodedReturnedPokemonsList[0]['url']),
            headers: anyNamed('headers')))
        .thenAnswer(
      (_) async => http.Response('Something is wrong', 404),
    );

    when(mockHttpClient.get(Uri.parse(decodedReturnedPokemonsList[1]['url']),
            headers: anyNamed('headers')))
        .thenAnswer(
      (_) async => http.Response('Something is wrong', 404),
    );
  }

  setUpMockJsonDecode({isMore = false}) {
    if (isMore) {
      when(jsonCodec.decode(rawMorePokemonsListJsonString))
          .thenReturn(tDecodedListMorePokemonsResponseMap);
      when(jsonCodec.decode(thirdPokemonJsonString))
          .thenReturn(tPokemonMaps[2]);
      when(jsonCodec.decode(fourthPokemonJsonString))
          .thenReturn(tPokemonMaps[3]);
    } else {
      when(jsonCodec.decode(rawPokemonsListJsonString))
          .thenReturn(tDecodedListInitialPokemonsResponseMap);
      when(jsonCodec.decode(firstPokemonJsonString))
          .thenReturn(tPokemonMaps[0]);
      when(jsonCodec.decode(secondPokemonJsonString))
          .thenReturn(tPokemonMaps[1]);
    }
  }

  setUpMockListPokemonSuccessResponse({isMore = false}) {
    if (isMore) {
      when(mockHttpClient.get(Uri.parse(LIST_POKEMONS_ENDPOINT + '&offset=2'),
              headers: anyNamed('headers')))
          .thenAnswer(
        (_) async => http.Response(fixture('list_more_pokemons.json'), 200),
      );
    } else {
      when(mockHttpClient.get(Uri.parse(LIST_POKEMONS_ENDPOINT),
              headers: anyNamed('headers')))
          .thenAnswer(
        (_) async => http.Response(fixture('list_pokemons.json'), 200),
      );
    }
  }

  setUpMockListPokemonFailureResponse({isMore = false}) {
    if (isMore) {
      when(mockHttpClient.get(Uri.parse(LIST_POKEMONS_ENDPOINT + '&offset=2'),
              headers: anyNamed('headers')))
          .thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );
    } else {
      when(mockHttpClient.get(Uri.parse(LIST_POKEMONS_ENDPOINT),
              headers: anyNamed('headers')))
          .thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );
    }
  }

  group('getInitialPokemons', () {
    test(
      '''should perform a GET request on the https://pokeapi.co/api/v2/pokemon endpoint
       and with an application/json header''',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse();
        setUpMockHttpPokemonDetailsSuccessResponse(
          firstPokemonJsonString: firstPokemonJsonString,
          secondPokemonJsonString: secondPokemonJsonString,
          decodedReturnedPokemonsList: decodedReturnedPokemonsList,
        );
        setUpMockJsonDecode();

        // act
        remoteDataSource.getInitialPokemons();

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(LIST_POKEMONS_ENDPOINT),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should get the list of returned pokemons list when the response code is a 200 (success)',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse();
        setUpMockHttpPokemonDetailsSuccessResponse(
          decodedReturnedPokemonsList: decodedReturnedPokemonsList,
          firstPokemonJsonString: firstPokemonJsonString,
          secondPokemonJsonString: secondPokemonJsonString,
        );
        setUpMockJsonDecode();

        // act
        await remoteDataSource.getInitialPokemons();

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(LIST_POKEMONS_ENDPOINT),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        verify(jsonCodec.decode(rawPokemonsListJsonString));
      },
    );

    test(
      'should perform a GET request to fetch the details of each pokemon returned from [LIST_POKEMONS_ENDPOINT]',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse();
        setUpMockHttpPokemonDetailsSuccessResponse(
          decodedReturnedPokemonsList: decodedReturnedPokemonsList,
          firstPokemonJsonString: firstPokemonJsonString,
          secondPokemonJsonString: secondPokemonJsonString,
        );
        setUpMockJsonDecode();

        // act
        await remoteDataSource.getInitialPokemons();

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(LIST_POKEMONS_ENDPOINT),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        verify(
          mockHttpClient.get(
            Uri.parse(decodedReturnedPokemonsList.first['url']),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return the list of pokemon models',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse();

        setUpMockHttpPokemonDetailsSuccessResponse(
          firstPokemonJsonString: firstPokemonJsonString,
          secondPokemonJsonString: secondPokemonJsonString,
          decodedReturnedPokemonsList: decodedReturnedPokemonsList,
        );
        setUpMockJsonDecode();
        // arrange jsonCodec stubs

        // act
        final result = await remoteDataSource.getInitialPokemons();

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(LIST_POKEMONS_ENDPOINT),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        verify(
          mockHttpClient.get(
            Uri.parse(decodedReturnedPokemonsList.first['url']),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final expectedPokemons =
            _getInitialTestPokemons(rawPokemonsListJsonString);

        expect(result, expectedPokemons);
      },
    );

    test(
      'should throw a ServerException when the response from [LIST_POKEMONS_ENDPOINT] is 404 or other',
      () async {
        // arrange
        setUpMockListPokemonFailureResponse();
        // act
        final call = remoteDataSource.getInitialPokemons;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw a ServerException when the response from pokemon details is 404 or other',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse();

        setUpMockHttpPokemonDetailsFailureResponse(
          decodedReturnedPokemonsList: decodedReturnedPokemonsList,
          firstPokemonJsonString: firstPokemonJsonString,
          secondPokemonJsonString: secondPokemonJsonString,
        );

        setUpMockJsonDecode();
        // act
        final call = remoteDataSource.getInitialPokemons;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getMorePokemons', () {
    const tMorePokemonsEndpoint = LIST_POKEMONS_ENDPOINT + '&offset=2';
    test(
      '''should perform a GET request on the https://pokeapi.co/api/v2/pokemon?limit=FETCH_LIMIT&offset=offset endpoint
       and with an application/json header''',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse(isMore: true);
        setUpMockHttpPokemonDetailsSuccessResponse(
          firstPokemonJsonString: thirdPokemonJsonString,
          secondPokemonJsonString: fourthPokemonJsonString,
          decodedReturnedPokemonsList:
              decodedReturnedPokemonsList.getRange(2, 4).toList(),
        );
        setUpMockJsonDecode(isMore: true);

        // act
        remoteDataSource.getMorePokemons(offset: 2);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(tMorePokemonsEndpoint),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should get the list of returned pokemons list when the response code is a 200 (success)',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse(isMore: true);
        setUpMockHttpPokemonDetailsSuccessResponse(
          decodedReturnedPokemonsList:
              decodedReturnedPokemonsList.getRange(2, 4).toList(),
          firstPokemonJsonString: thirdPokemonJsonString,
          secondPokemonJsonString: fourthPokemonJsonString,
        );
        setUpMockJsonDecode(isMore: true);

        // act
        await remoteDataSource.getMorePokemons(offset: 2);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(tMorePokemonsEndpoint),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        verify(jsonCodec.decode(rawMorePokemonsListJsonString));
      },
    );

    test(
      'should perform a GET request to fetch the details of each pokemon returned from [LIST_POKEMONS_ENDPOINT]',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse(isMore: true);
        setUpMockHttpPokemonDetailsSuccessResponse(
          decodedReturnedPokemonsList:
              decodedReturnedPokemonsList.getRange(2, 4).toList(),
          firstPokemonJsonString: thirdPokemonJsonString,
          secondPokemonJsonString: fourthPokemonJsonString,
        );
        setUpMockJsonDecode(isMore: true);

        // act
        await remoteDataSource.getMorePokemons(offset: 2);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(tMorePokemonsEndpoint),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        verify(
          mockHttpClient.get(
            Uri.parse(decodedReturnedPokemonsList[2]['url']),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return the list of pokemon models',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse(isMore: true);

        setUpMockHttpPokemonDetailsSuccessResponse(
          firstPokemonJsonString: thirdPokemonJsonString,
          secondPokemonJsonString: fourthPokemonJsonString,
          decodedReturnedPokemonsList:
              decodedReturnedPokemonsList.getRange(2, 4).toList(),
        );
        setUpMockJsonDecode(isMore: true);
        // arrange jsonCodec stubs

        // act
        final result = await remoteDataSource.getMorePokemons(offset: 2);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse(tMorePokemonsEndpoint),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        verify(
          mockHttpClient.get(
            Uri.parse(decodedReturnedPokemonsList[2]['url']),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final expectedPokemons =
            _getMoreTestPokemons(rawMorePokemonsListJsonString);

        expect(result, expectedPokemons);
      },
    );

    test(
      'should throw a ServerException when the response from [LIST_POKEMONS_ENDPOINT] is 404 or other',
      () async {
        // arrange
        setUpMockListPokemonFailureResponse(isMore: true);
        // act
        final call = remoteDataSource.getMorePokemons;

        // assert
        expect(() => call(offset: 2), throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw a ServerException when the response from pokemon details is 404 or other',
      () async {
        // arrange
        setUpMockListPokemonSuccessResponse(isMore: true);

        setUpMockHttpPokemonDetailsFailureResponse(
          decodedReturnedPokemonsList:
              decodedReturnedPokemonsList.getRange(2, 4).toList(),
          firstPokemonJsonString: thirdPokemonJsonString,
          secondPokemonJsonString: fourthPokemonJsonString,
        );

        setUpMockJsonDecode(isMore: true);
        // act
        final call = remoteDataSource.getMorePokemons;

        // assert
        expect(() => call(offset: 2), throwsA(isA<ServerException>()));
      },
    );
  });
}

List<PokemonModel> _getInitialTestPokemons(String fixture) {
  final pokemonJsonMaps = _getTestPokemonJsonMaps();
  return List.generate(
      2, (index) => PokemonModel.fromJson(pokemonJsonMaps[index]));
}

List<PokemonModel> _getMoreTestPokemons(String fixture) {
  final pokemonJsonMaps = _getTestPokemonJsonMaps().getRange(2, 4).toList();
  return List.generate(
      2, (index) => PokemonModel.fromJson(pokemonJsonMaps[index]));
}

List<Map<String, dynamic>> _getDecodedPokemonsList() {
  return [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
    {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"},
    {"name": "venusaur", "url": "https://pokeapi.co/api/v2/pokemon/3/"},
    {"name": "charmander", "url": "https://pokeapi.co/api/v2/pokemon/4/"}
  ];
}

List<Map<String, dynamic>> _getTestPokemonJsonMaps() {
  return [
    {
      "height": 7,
      "id": 1,
      "name": "bulbasaur",
      "sprites": {
        "official-artwork": {
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        }
      },
      "stats": [
        {
          "base_stat": 45,
          "stat": {"name": "hp"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "attack"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "defense"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-attack"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-defense"}
        },
        {
          "base_stat": 45,
          "stat": {"name": "speed"}
        }
      ],
      "types": [
        {
          "type": {"name": "grass"}
        },
        {
          "type": {"name": "poison"}
        }
      ],
      "weight": 69
    },
    {
      "height": 7,
      "id": 2,
      "name": "ivysaur",
      "sprites": {
        "official-artwork": {
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        }
      },
      "stats": [
        {
          "base_stat": 45,
          "stat": {"name": "hp"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "attack"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "defense"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-attack"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-defense"}
        },
        {
          "base_stat": 45,
          "stat": {"name": "speed"}
        }
      ],
      "types": [
        {
          "type": {"name": "grass"}
        },
        {
          "type": {"name": "poison"}
        }
      ],
      "weight": 69
    },
    {
      "height": 7,
      "id": 3,
      "name": "venusaur",
      "sprites": {
        "official-artwork": {
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        }
      },
      "stats": [
        {
          "base_stat": 45,
          "stat": {"name": "hp"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "attack"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "defense"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-attack"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-defense"}
        },
        {
          "base_stat": 45,
          "stat": {"name": "speed"}
        }
      ],
      "types": [
        {
          "type": {"name": "grass"}
        },
        {
          "type": {"name": "poison"}
        }
      ],
      "weight": 69
    },
    {
      "height": 7,
      "id": 4,
      "name": "charmander",
      "sprites": {
        "official-artwork": {
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        }
      },
      "stats": [
        {
          "base_stat": 45,
          "stat": {"name": "hp"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "attack"}
        },
        {
          "base_stat": 49,
          "stat": {"name": "defense"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-attack"}
        },
        {
          "base_stat": 65,
          "stat": {"name": "special-defense"}
        },
        {
          "base_stat": 45,
          "stat": {"name": "speed"}
        }
      ],
      "types": [
        {
          "type": {"name": "grass"}
        },
        {
          "type": {"name": "poison"}
        }
      ],
      "weight": 69
    },
  ];
}

Map<String, dynamic> get tDecodedListInitialPokemonsResponseMap => {
      "count": 1126,
      "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
      "previous": null,
      "results": [
        {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
        {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
      ]
    };

Map<String, dynamic> get tDecodedListMorePokemonsResponseMap => {
      "count": 1126,
      "next": null,
      "previous": null,
      "results": [
        {"name": "venusaur", "url": "https://pokeapi.co/api/v2/pokemon/3/"},
        {"name": "charmander", "url": "https://pokeapi.co/api/v2/pokemon/4/"}
      ]
    };
