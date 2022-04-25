import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/constants/assets.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/app_divider.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/pokemon_card.dart';
import 'package:string_extensions/string_extensions.dart';

enum DisplayState {
  allPokemons,
  favoritePokemons,
}

class PokemonHomeScreen extends StatefulWidget {
  static const routeName = '/pokemon-home-screen';
  const PokemonHomeScreen({Key? key}) : super(key: key);

  @override
  State<PokemonHomeScreen> createState() => _PokemonHomeScreenState();
}

class _PokemonHomeScreenState extends State<PokemonHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final List<GlobalKey<AnimatorWidgetState>> _animKeys;

  List<Pokemon> _pokemons = [];
  List<Pokemon> _favoritePokemons = [];

  DisplayState currentDisplayState = DisplayState.allPokemons;

  bool canLoadMorePokemons = true;

  List<Widget> get pokemonWidgets => _getPokemonWidgets();

  @override
  void initState() {
    _loadInitialPokemons();
    _initializeTabBarAnimation(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HelperFunctions.setStatusBarDarkTheme();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: _buildAppBar(),
      ),
      body: SafeArea(
        child: BlocConsumer<PokemonBloc, PokemonState>(
          listener: _handlePageListener,
          builder: (context, state) {
            if (_pokemons.isEmpty) {
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
                        backgroundColor:
                            AppColors.ceruleanBlue.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.ceruleanBlue),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Color(0xFFE8E8E8),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
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

  @override
  void dispose() {
    _disposeAnimationComponents();
    super.dispose();
  }

  void _handlePageListener(BuildContext context, PokemonState state) {
    if (state is PokemonsLoadedState) {
      _pokemons.addAll(state.pokemons);
      _favoritePokemons =
          _pokemons.where((element) => element.id % 2 == 1).toList();
      setState(() {
        canLoadMorePokemons = true;
      });
    } else if (state is LoadInitialPokemonErrorState) {
      log(state.message);
    } else if (state is PokemonAddedToFavoriteState) {
      setState(() {
        _pokemons = state.newPokemons;
      });
    } else if (state is PokemonRemovedFromFavoriteState) {
      setState(() {
        _pokemons = state.newPokemons;
      });
    }
    log(state.runtimeType.toString());
  }

  void _loadInitialPokemons() {
    BlocProvider.of<PokemonBloc>(context).add(LoadInitialPokemonsEvent());
  }

  void _animationStatus() {
    if (_tabController.animation!.status == AnimationStatus.forward) {
      print('Going forward');
      // _animKeys[_tabController.index].currentState!.forward();
    }
  }

  void _initializeTabBarAnimation(
      _PokemonHomeScreenState _pokemonHomeScreenState) {
    _tabController = TabController(length: 2, vsync: _pokemonHomeScreenState);
    // ..animation!.addListener(_animationStatus);

    _animKeys = List.generate(
      2,
      (index) => GlobalKey<AnimatorWidgetState>(),
    );
  }

  void _disposeAnimationComponents() {
    for (var key in _animKeys) {
      if (key.currentState != null) {
        key.currentState!.dispose();
      }
    }
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
          TabBar(
            tabs: [
              Tab(
                child: Text(
                  'First',
                  // style: Theme.of(context).textTheme.headlineLarge,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'Second',
                  // style: Theme.of(context).textTheme.headlineLarge,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            indicatorWeight: 3,
            // indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              color: AppColors.darkGunmetal,
            ),
            controller: _tabController,
            onTap: _handleTabBarTap,
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
    return displayState == currentDisplayState ? true : false;
  }

  void _loadMorePokemons() {
    BlocProvider.of<PokemonBloc>(context).add(
      LoadMorePokemonsEvent(offset: _pokemons.length),
    );
  }

  List<Widget> _getPokemonWidgets() {
    if (displayIs(DisplayState.allPokemons)) {
      return List.generate(
        _pokemons.length,
        (index) {
          final pokemon = _pokemons[index];
          return PokemonCard(
              key: Key(pokemon.id.toString()), pokemon: pokemon, index: index);
        },
      );
    } else {
      return List.generate(
        _favoritePokemons.length,
        (index) {
          final pokemon = _favoritePokemons[index];
          return PokemonCard(
              key: Key(pokemon.id.toString()), pokemon: pokemon, index: index);
        },
      );
    }
  }

  void _handleTabBarTap(int value) {
    if (value == 0) {
      setState(() {
        currentDisplayState = DisplayState.allPokemons;
      });
    } else {
      setState(() {
        currentDisplayState = DisplayState.favoritePokemons;
      });
    }
    // _animKeys[value].currentState!.forward();
  }
}
