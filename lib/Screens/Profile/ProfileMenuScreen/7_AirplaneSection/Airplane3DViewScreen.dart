import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
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

  const Airplane3DViewScreen({super.key, required this.selectedPart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AirPlanePartsCubit(context: context),
      child: _Airplane3DView(selectedPart: selectedPart),
    );
  }
}

class _Airplane3DView extends StatelessWidget {
  final AirPlanePartsModel selectedPart;

  const _Airplane3DView({required this.selectedPart});

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
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      "3D View",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold(
                        isDesktopWeb ? 20 : 20,
                      ).copyWith(color: AppColors.primaryDark),
                    ),

                    const SizedBox(height: 14),

                    _AircraftPreview(
                      part: selectedPart,
                      isAircraftUnlocked:
                          selectedPart.collectedCount >=
                          selectedPart.totalCount,
                      isDesktopWeb: isDesktopWeb,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.dragRotateIcon),
                          width: 30,
                          height: 27,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Drag to rotate",
                          style: AppTextStyles.semiBold(
                            isDesktopWeb ? 13 : 15,
                          ).copyWith(color: const Color(0xFF575757)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktopWeb ? 30 : 12,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: selectedPart.subParts.length,
                          itemBuilder: (context, index) {
                            final subPart = selectedPart.subParts[index];

                            final bool isUnlocked =
                                index < selectedPart.collectedCount;

                            return Airplane3DSubPartCard(
                              subPart: subPart,
                              isUnlocked: isUnlocked,
                              isDesktopWeb: isDesktopWeb,
                            );
                          },
                        ),
                      ),
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

class _AircraftPreview extends StatefulWidget {
  final AirPlanePartsModel part;
  final bool isAircraftUnlocked;
  final bool isDesktopWeb;

  const _AircraftPreview({
    required this.part,
    required this.isAircraftUnlocked,
    required this.isDesktopWeb,
  });

  @override
  State<_AircraftPreview> createState() => _AircraftPreviewState();
}

class _AircraftPreviewState extends State<_AircraftPreview> {
  late final Flutter3DController _controller;

  bool _isLoading3D = true;

  @override
  void initState() {
    super.initState();

    _controller = Flutter3DController();

    _controller.onModelLoaded.addListener(() {
      if (_controller.onModelLoaded.value && mounted) {
        setState(() {
          _isLoading3D = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.isDesktopWeb ? 820 : 340,
        height: widget.isDesktopWeb ? 320 : 190,
        decoration: BoxDecoration(
          color: const Color(0xffEDEDED),
          borderRadius: BorderRadius.circular(
            widget.isDesktopWeb ? 24 : 20,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.part.modelPath.isNotEmpty)
              Positioned.fill(
                child: Opacity(
                  opacity: widget.isAircraftUnlocked ? 1.0 : 0.35,
                  child: Flutter3DViewer(
                    controller: _controller,
                    src: widget.part.modelPath,
                    progressBarColor: Colors.transparent,
                  ),
                ),
              ),

            if (_isLoading3D)
              const Center(
                child: CircularProgressIndicator(
                ),
              ),

            if (!widget.isAircraftUnlocked)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),

            if (!widget.isAircraftUnlocked)
              Positioned.fill(
                child: Center(
                  child: SvgPicture.asset(
                    CommonUi.setSvgImage(
                      AssetsPath.badgesLockIcon,
                    ),
                    width: widget.isDesktopWeb ? 48 : 42,
                    height: widget.isDesktopWeb ? 48 : 42,
                    fit: BoxFit.contain,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Airplane3DSubPartCard extends StatelessWidget {
  final AirPlaneSubPartModel subPart;
  final bool isUnlocked;
  final bool isDesktopWeb;

  const Airplane3DSubPartCard({
    super.key,
    required this.subPart,
    required this.isUnlocked,
    required this.isDesktopWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktopWeb ? 120 : 105,
      ),
      margin: const EdgeInsets.only(bottom: 7),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktopWeb ? 16 : 10,
        vertical: isDesktopWeb ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : const Color(0xffD0D0D0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffBDBDBD),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semiBold(
                    isDesktopWeb ? 17 : 20,
                  ).copyWith(
                    color: isUnlocked
                        ? AppColors.primaryDark
                        : const Color(0xff777777),
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
            style: AppTextStyles.semiBold(
              isDesktopWeb ? 14 : 14,
            ).copyWith(
              color: isUnlocked
                  ? AppColors.black
                  : const Color(0xff777777),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
