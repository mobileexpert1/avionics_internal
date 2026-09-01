import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../bloc/Profile/AirmanshipBadges/AirmanshipBadgesCubit.dart';
import '../../../../bloc/Profile/AirmanshipBadges/AirmanshipBadgesState.dart';
import '../8_Sticker/FlightStickers/StickerParticularCard.dart';

class AirmanshipBadgesScreen extends StatefulWidget {
  const AirmanshipBadgesScreen({super.key});

  @override
  State<AirmanshipBadgesScreen> createState() => _AirmanshipBadgesScreenState();
}

class _AirmanshipBadgesScreenState extends State<AirmanshipBadgesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AirmanshipBadgesCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Airmanship Badges',
          centerTitle: false,
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: BlocBuilder<AirmanshipBadgesCubit, AirmanshipBadgesState>(
          builder: (context, state) {
            if (state.categories.isEmpty) {
              return const Center(
                child: Text('No Airmanship Badges available'),
              );
            }

            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                children: [
                  // Static Title - only once
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Badges unlock',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ...state.categories.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Title
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            category.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: category.badges.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.0,
                              ),
                          itemBuilder: (context, badgeIndex) {
                            final badge = category.badges[badgeIndex];

                            return StickerCard(
                              airmanshipBadge: badge,
                              onTap: () {},
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
