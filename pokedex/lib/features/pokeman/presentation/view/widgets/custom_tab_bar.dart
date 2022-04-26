import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/utils.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    Key? key,
    required this.favoritePokemonsCount,
    required this.onTapped,
    required this.width,
  }) : super(key: key);

  final int favoritePokemonsCount;
  final ValueSetter<DisplayState> onTapped;
  final double width;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final _globalKey = GlobalKey();

  TextStyle get currentTabTextStyle => const TextStyle(
        color: AppColors.darkGunmetal,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get unselectedTabTextStyle => const TextStyle(
        color: AppColors.dimGray,
        fontSize: 16,
      );

  double? left = 0.0;
  double? right = 0.0;

  @override
  void initState() {
    super.initState();
    right = widget.width / 2;
  }

  DisplayState currentDisplayState = DisplayState.allPokemons;
  @override
  Widget build(BuildContext context) {
    return Column(
      key: _globalKey,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () => _handleOnTapBarTapped(DisplayState.allPokemons),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'All Pokemons',
                      // style: Theme.of(context).textTheme.headlineLarge,
                      style: displayIs(DisplayState.allPokemons)
                          ? currentTabTextStyle
                          : unselectedTabTextStyle,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () =>
                    _handleOnTapBarTapped(DisplayState.favoritePokemons),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Favourites',
                          // style: Theme.of(context).textTheme.headlineLarge,
                          style: displayIs(DisplayState.favoritePokemons)
                              ? currentTabTextStyle
                              : unselectedTabTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.ceruleanBlue,
                          ),
                          child: Center(
                            child: Text(
                              widget.favoritePokemonsCount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
          child: Stack(
            children: [
              AnimatedPositioned(
                left: left,
                right: right,
                // width: widget.width / 2,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.ceruleanBlue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 400),
                // curve: Curves.,
              )
            ],
          ),
        ),
      ],
    );
  }

  bool displayIs(DisplayState displayState) {
    return displayState == currentDisplayState ? true : false;
  }

  _handleOnTapBarTapped(DisplayState tappedDisplayBar) {
    if (currentDisplayState == tappedDisplayBar) return;

    widget.onTapped(tappedDisplayBar);
    if (tappedDisplayBar == DisplayState.allPokemons) {
      left = 0;
      right = (widget.width / 2);
    } else {
      left = widget.width / 2;
      right = 0;
    }
    setState(() {
      currentDisplayState = tappedDisplayBar;
    });
  }
}
