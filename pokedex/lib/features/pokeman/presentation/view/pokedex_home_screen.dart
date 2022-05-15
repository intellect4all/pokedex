import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/constants/assets.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_helper.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/app_divider.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/custom_tab_bar.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/pokemon_card.dart';

class PokemonHomeScreen extends StatefulWidget {
  static const routeName = '/pokemon-home-screen';
  const PokemonHomeScreen({Key? key}) : super(key: key);

  @override
  State<PokemonHomeScreen> createState() => _PokemonHomeScreenState();
}

class _PokemonHomeScreenState extends State<PokemonHomeScreen> {
  late PokemonHelper _pokemonHelper;

  List<Pokemon> _pokemons = [];
  List<Pokemon> get favoritePokemons =>
      _pokemons.where((element) => element.isFavorite).toList();

  DisplayState currentDisplayState = DisplayState.allPokemons;

  int offset = 0;

  bool canLoadMorePokemons = true;

  List<Widget> get pokemonWidgets => _getPokemonWidgets();
  bool get isBigScreen => MediaQuery.of(context).size.width > 600;

  @override
  void initState() {
    _pokemonHelper = PokemonHelper();
    _loadInitialPokemons();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HelperFunctions.setStatusBarDarkTheme();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(125),
        child: _buildAppBar(),
      ),
      body: SafeArea(
        child: BlocConsumer<PokemonBloc, PokemonState>(
          listener: _handlePageListener,
          builder: (context, state) {
            if (state is LoadInitialPokemonErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Error fetching your pokemons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please check your internet and click the button below to try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _loadInitialPokemons,
                      child: const Text('Reload'),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.ceruleanBlue,
                      ),
                    ),
                  ],
                ),
              ).space(left: 30, right: 30);
            } else if (_pokemons.isEmpty) {
              return _buildInitialLoadingWidgets();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFFE8E8E8),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: _handleScrollNotification,
                        child: ReorderableBuilder(
                          children: pokemonWidgets,
                          enableDraggable: false,
                          enableLongPress: false,
                          builder: (children, scrollController) {
                            return GridView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isBigScreen ? 6 : 3,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 220,
                              ),
                              children: children,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Center _buildInitialLoadingWidgets() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Welcome,',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'we are fetching initial pokemons for you',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              backgroundColor: AppColors.ceruleanBlue.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.ceruleanBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handlePageListener(BuildContext context, PokemonState state) {
    if (state is PokemonsLoadedState) {
      _pokemons = _pokemonHelper
          .cleansPokemons(
            newPokemons: state.pokemons,
            currentPokemons: _pokemons,
          )
          .toList();

      setState(() {
        canLoadMorePokemons = true;
        offset += 20;
      });
    } else if (state is LoadInitialPokemonErrorState) {
      setState(() {
        canLoadMorePokemons = true;
      });
      _showErrorSnackBar(state.message);
    } else if (state is LoadMorePokemonErrorState) {
      setState(() {
        canLoadMorePokemons = true;
      });
      _showErrorSnackBar(state.message);
    } else if (state is PokemonAddedToFavoriteState) {
      _pokemons = _pokemonHelper.changePokemonFavoriteState(
        pokemon: state.pokemon,
        isFavorite: true,
        pokemons: _pokemons,
      );
      setState(() {});
    } else if (state is PokemonRemovedFromFavoriteState) {
      _pokemons = _pokemonHelper.changePokemonFavoriteState(
        pokemon: state.pokemon,
        isFavorite: false,
        pokemons: _pokemons,
      );
      setState(() {});
    }
  }

  void _loadInitialPokemons() {
    BlocProvider.of<PokemonBloc>(context).add(LoadInitialPokemonsEvent());
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.logo,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Pokedex',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 24,
                      height: 32 / 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ).space(top: 5, bottom: 5),
          const AppDivider(
            thickness: 3,
          ),
          CustomTabBar(
            favoritePokemonsCount: favoritePokemons.length,
            width: MediaQuery.of(context).size.width,
            onTapped: (DisplayState displayState) {
              setState(() {
                currentDisplayState = displayState;
              });
            },
          ),
          if (!canLoadMorePokemons) _buildTopProgressIndicator(),
        ],
      ),
    );
  }

  LinearProgressIndicator _buildTopProgressIndicator() {
    return LinearProgressIndicator(
      minHeight: 10,
      backgroundColor: AppColors.ceruleanBlue.withOpacity(0.3),
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.ceruleanBlue),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (canLoadMorePokemons && displayIs(DisplayState.allPokemons)) {
        _loadMorePokemons();
        setState(() {
          canLoadMorePokemons = false;
        });
      }
    }
    return false;
  }

  bool displayIs(DisplayState displayState) {
    return displayState == currentDisplayState;
  }

  void _loadMorePokemons() {
    BlocProvider.of<PokemonBloc>(context).add(
      LoadMorePokemonsEvent(offset: offset),
    );
  }

  List<Widget> _getPokemonWidgets() {
    if (displayIs(DisplayState.allPokemons)) {
      return List.generate(
        _pokemons.length,
        (index) {
          final pokemon = _pokemons[index];
          return PokemonCard(
            key: Key(pokemon.id.toString()),
            pokemon: pokemon,
            pokemanIndex: index,
          );
        },
      );
    } else {
      return List.generate(
        favoritePokemons.length,
        (index) {
          final pokemon = favoritePokemons[index];
          return PokemonCard(
            key: Key(pokemon.id.toString()),
            pokemon: pokemon,
            pokemanIndex: index,
          );
        },
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.ceruleanBlue,
          ),
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Error',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ).space(
                bottom: 10,
              ),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
