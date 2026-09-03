import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    return BlocProvider(
      create: (_) => AirmanshipBadgesCubit()..loadAirmanshipBadges(context),
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
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CommonApiStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            if (state.categories.isEmpty) {
              return const Center(
                child: Text('No Airmanship Badges available'),
              );
            }

            return SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktopWeb ? 900 : double.infinity,
                  ),
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktopWeb
                          ? 30
                          : isMobileWeb
                          ? 12
                          : 10,
                      vertical: 8,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isDesktopWeb ? 8 : 8,
                        ),
                        child: Text(
                          'Badges unlock',
                          style: TextStyle(
                            fontSize: isDesktopWeb ? 20 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      ...state.categories.map((category) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isDesktopWeb ? 8 : 8,
                              ),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: isDesktopWeb ? 20 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: category.badges.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: isDesktopWeb ? 10 : 10,
                                    mainAxisSpacing: isDesktopWeb ? 10 : 10,
                                    childAspectRatio: isDesktopWeb ? 1.0 : 1.0,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
