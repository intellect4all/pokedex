import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/strings.dart';
import 'package:pokedex/features/pokeman/presentation/pokemon_bloc.dart';
import 'package:pokedex/features/pokeman/presentation/view/pokedex_home_screen.dart';
import 'package:pokedex/page_not_found_screen.dart';
import 'package:pokedex/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  await di.init();
  runApp(BlocProvider(
    create: (context) => sl<PokemonBloc>(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        theme: ThemeData(
          fontFamily: 'Noto Sans',
        ),
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: _registerCupertinoRoutes);
  }

  Route? _registerCupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case PokemonHomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const PokemonHomeScreen(),
          settings: settings,
        );

      default:
        // A 404 page can be here
        return MaterialPageRoute(
          builder: (_) => const PageNotFoundScreen(),
          settings: settings,
        );
    }
  }
}
