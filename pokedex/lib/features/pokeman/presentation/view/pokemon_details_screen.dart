import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/constants/assets.dart';
import 'package:pokedex/core/constants/colors.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/features/pokeman/domain/entities/all_stats.dart';
import 'package:pokedex/features/pokeman/domain/entities/base_stat_type.dart';
import 'package:pokedex/features/pokeman/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/app_divider.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/favorite_pokemon_fab.dart';
import 'package:pokedex/features/pokeman/presentation/view/widgets/pokemon_image.dart';
import 'package:string_extensions/string_extensions.dart';

class PokemonDetailsScreen extends StatelessWidget {
  static const routeName = '/pokemon-details-screen';

  final Pokemon pokemon;
  final Color? color;
  const PokemonDetailsScreen({
    Key? key,
    required this.pokemon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: color ?? AppColors.honeyDew,
            expandedHeight: 50.0,
            automaticallyImplyLeading: false,
            pinned: true,
            flexibleSpace: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () => Navigation.back(context),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Icon(
                  Icons.chevron_left,
                ),
              ).space(left: 15, bottom: 15),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                final children = _getChildren();
                return children[index];
              },
              childCount: _getChildren().length,
            ),
          )
        ],
      ),
      floatingActionButton: FavoritePokemonFAB(pokemon: pokemon),
    );
  }

  Widget _buildHeightWeightBMISection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      height: 80,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.dimGray.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          _buildLayeredText(
            title: 'Height',
            value: pokemon.height,
          ),
          _buildLayeredText(
            title: 'Weight',
            value: pokemon.weight,
          ),
          _buildLayeredText(
            title: 'BMI',
            value: pokemon.getBMI.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }

  Widget _buildLayeredText({
    required String title,
    required dynamic value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            height: 24 / 12,
            fontWeight: FontWeight.w500,
            color: AppColors.dimGray,
          ),
        ).space(bottom: 2),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkGunmetal,
          ),
        ),
      ],
    ).space(right: 48);
  }

  Widget _buildPokemonImage() {
    return Container(
      height: 200,
      color: color ?? AppColors.honeyDew,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            right: -35,
            bottom: -22,
            child: SizedBox(
              height: 176,
              width: 176,
              child: SvgPicture.asset(
                Assets.pokemonImageBackGround,
                height: 176,
                width: 176,
                color: _getSvgColor(),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 2,
            child: PokemonImageWidget(
              pokemon: pokemon,
              size: const Size(125, 136),
            ),
          ),
          _buildPokemonIdentityTexts(),
        ],
      ),
    );
  }

  Widget _buildPokemonIdentityTexts() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pokemon.name.toTitleCase!,
            style: const TextStyle(
              color: AppColors.darkGunmetal,
              fontSize: 32,
              height: 43 / 32,
              fontWeight: FontWeight.bold,
            ),
          ).space(bottom: 5),
          Text(
            HelperFunctions.joinListToString(pokemon.types),
            style: const TextStyle(
              color: AppColors.darkGunmetal,
              fontSize: 16,
            ),
          ).space(bottom: 5),
          const Spacer(),
          Text(
            HelperFunctions.formatPokemonId(pokemon.id),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkGunmetal,
            ),
          ).space(
            bottom: 2,
          )
        ],
      ),
    );
  }

  Widget _buildStatSection(AllStats stats) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Base stats',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGunmetal,
            ),
          ).space(left: 16, right: 16, top: 12, bottom: 12),
          const AppDivider(height: 0, thickness: 2),
          _buildStatItem(
            stat: stats.hp,
          ),
          _buildStatItem(
            stat: stats.attack,
            valueColor: AppColors.deepLemon,
          ),
          _buildStatItem(
            stat: stats.defense,
            valueColor: AppColors.ceruleanBlue,
          ),
          _buildStatItem(
            stat: stats.specialAttack,
          ),
          _buildStatItem(
            stat: stats.specialDefense,
            valueColor: AppColors.maximumGreen,
          ),
          _buildStatItem(
            stat: stats.speed,
            valueColor: AppColors.palatinateBlue,
          ),
          _buildStatItem(
            title: 'Avg. Power',
            value: stats.getAveragePower.toInt(),
            valueColor: Colors.red,
          ),
        ],
      ),
    );
  }

  ///! if `stat` is null, `title` and `value` must not be null
  Widget _buildStatItem({
    BaseStatType? stat,
    String? title,
    int? value,
    Color? valueColor,
  }) {
    final percentageValue = (stat?.value ?? value!) / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: (stat?.name ?? title!) + '  ',
              style: const TextStyle(
                color: AppColors.dimGray,
              ),
              children: [
                TextSpan(
                  text: (stat?.value ?? value!).toString(),
                  style: const TextStyle(
                    color: AppColors.darkGunmetal,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
        ),
        const SizedBox(height: 10),
        LinearPercentageIndicator(
          percentageValue: percentageValue,
          valueColor: valueColor,
        ),
      ],
    ).space(left: 16, right: 16, top: 12, bottom: 15);
  }

  List<Widget> _getChildren() {
    return [
      const AppDivider(
        height: 0,
        thickness: 4,
        color: Colors.red,
      ),
      _buildPokemonImage(),
      _buildHeightWeightBMISection(),
      _buildStatSection(pokemon.stats)
    ];
  }

  Color? _getSvgColor() {
    if (color == null) return AppColors.dirtyWhite;
    if (color == AppColors.aliceBlue) return AppColors.greenBlue;
    if (color == AppColors.lavendarBlush) return AppColors.paleLavendar2;
  }
}

class LinearPercentageIndicator extends StatelessWidget {
  /// * must be between 0 and 1.0
  final double percentageValue;
  final Color? valueColor;
  final Color? backGroundColor;
  final double? width;
  const LinearPercentageIndicator({
    Key? key,
    required this.percentageValue,
    this.valueColor,
    this.backGroundColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final length = width ?? (MediaQuery.of(context).size.width - 40);
    return Stack(
      children: [
        Container(
          height: 4,
          width: length,
          decoration: BoxDecoration(
            color: backGroundColor ?? AppColors.platinum,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Container(
          height: 4,
          width: length * percentageValue,
          decoration: BoxDecoration(
            color: valueColor ?? AppColors.magentaDye,
            borderRadius: BorderRadius.circular(30),
          ),
        )
      ],
    );
  }
}
