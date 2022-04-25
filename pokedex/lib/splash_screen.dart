import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/core/constants/assets.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/navigation.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/features/pokeman/presentation/view/pokedex_home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    HelperFunctions.setStatusBarToLightTheme();
    _navigateToHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ceruleanBlue,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.logo,
                height: 75,
                width: 75,
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'POKEMON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 21.79 / 16,
                      letterSpacing: 4,
                    ),
                  ),
                  Text(
                    'Pokedex',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      height: 60 / 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToHomeScreen() async {
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigation.intent(
        context,
        PokemonHomeScreen.routeName,
      ),
    );
  }
}
