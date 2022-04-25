import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/colors.dart';

class PageNotFoundScreen extends StatelessWidget {
  static const routeName = '/page-not-found';
  const PageNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.ceruleanBlue,
      body: Center(
        child: Text(
          'The page you are looking for cannot be found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
