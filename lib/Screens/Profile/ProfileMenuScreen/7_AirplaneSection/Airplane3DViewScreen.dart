import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsCubit.dart';
import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsModel.dart';
import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsState.dart';

class Airplane3DViewScreen extends StatelessWidget {
  final AirPlanePartsModel selectedPart;

  const Airplane3DViewScreen({
    super.key,
    required this.selectedPart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AirPlanePartsCubit(),
      child: _Airplane3DView(
        selectedPart: selectedPart,
      ),
    );
  }
}

class _Airplane3DView extends StatelessWidget {
  final AirPlanePartsModel selectedPart;

  const _Airplane3DView({
    required this.selectedPart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: "Plane Spotter",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: BlocBuilder<AirPlanePartsCubit, AirPlanePartsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage ?? ''));
          }

          final bool isAircraftUnlocked =
              state.totalCount > 0 && state.unlockedCount >= state.totalCount;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktopWeb
                        ? 30
                        : isMobileWeb
                        ? 12
                        : 12,
                    vertical: 12,
                  ),
                  children: [
                    Text(
                      "3D View",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold(
                        isDesktopWeb ? 20 : 17,
                      ).copyWith(color: AppColors.primaryDark),
                    ),

                    const SizedBox(height: 12),

                    _AircraftPreview(
                      parts: state.parts,
                      isAircraftUnlocked: isAircraftUnlocked,
                      isDesktopWeb: isDesktopWeb,
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.swap_horiz,
                          size: 22,
                          color: Color(0xff777777),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Drag to rotate",
                          style: AppTextStyles.regular(
                            isDesktopWeb ? 13 : 12,
                          ).copyWith(color: AppColors.black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      selectedPart.subParts.length,
                          (index) {
                        final subPart = selectedPart.subParts[index];

                        return Airplane3DSubPartCard(
                          subPart: subPart,
                          isDesktopWeb: isDesktopWeb,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AircraftPreview extends StatelessWidget {
  final List<AirPlanePartsModel> parts;
  final bool isAircraftUnlocked;
  final bool isDesktopWeb;

  const _AircraftPreview({
    required this.parts,
    required this.isAircraftUnlocked,
    required this.isDesktopWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isDesktopWeb ? 250 : 135,
      decoration: BoxDecoration(
        color: const Color(0xffE7E7E7),
        borderRadius: BorderRadius.circular(isDesktopWeb ? 24 : 20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (parts.isNotEmpty)
            Opacity(
              opacity: isAircraftUnlocked ? 1.0 : 0.35,
              child: Image.asset(
                parts.first.image,
                width: isDesktopWeb ? 260 : 160,
                height: isDesktopWeb ? 200 : 105,
                fit: BoxFit.contain,
              ),
            ),

          if (!isAircraftUnlocked)
            SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.badgesLockIcon),
              width: isDesktopWeb ? 42 : 32,
              height: isDesktopWeb ? 42 : 32,
              fit: BoxFit.contain,
              color: AppColors.primaryDark,
            ),
        ],
      ),
    );
  }
}

class Airplane3DSubPartCard extends StatelessWidget {
  final AirPlaneSubPartModel subPart;
  final bool isDesktopWeb;

  const Airplane3DSubPartCard({
    super.key,
    required this.subPart,
    required this.isDesktopWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktopWeb ? 16 : 10,
        vertical: isDesktopWeb ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffBDBDBD),
        ),
      ),
      child: Column(
        children: [

          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Color(0xffB5B5B5),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  subPart.name,
                  style: AppTextStyles.bold(
                    isDesktopWeb ? 14 : 13,
                  ).copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),

              const Expanded(
                child: Divider(
                  color: Color(0xffB5B5B5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            subPart.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular(
              isDesktopWeb ? 12 : 10,
            ).copyWith(
              color: AppColors.black,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
