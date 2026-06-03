import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../Helpers/Custom_widget.dart';
import '../../../Helpers/StringCommonMethods.dart';
import '../../../bloc/Home/manufacturer/Manufacturer_detail_model.dart';
import '../../../bloc/Home/manufacturer/manufacturer_cubit.dart';
import '../../../bloc/Home/manufacturer/manufacturer_state.dart';
import '../../Profile/SettingScreen/SettingScreen.dart';
import '../HomeAirbus/AllPlaneListAndDetails/AllPlaneListScreen.dart';

class ManufacturerDetailScreen extends StatefulWidget {
  final String manufacturerDetailId;

  const ManufacturerDetailScreen({
    super.key,
    required this.manufacturerDetailId,
  });

  @override
  State<ManufacturerDetailScreen> createState() => _AirbusScreenState();
}

class _AirbusScreenState extends State<ManufacturerDetailScreen> {
  bool showMoreGeneralInfo = true;
  bool showMoreAboutInfo = false;
  bool showMoreHistory = false;
  bool showMoreProducts = false;
  bool showInterestingFacts = false;
  int expandedIndex = -1;
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ManufacturerCubit>();
    cubit.emit(cubit.state.copyWith(manufacturerDetail: null, isLoading: true));

    context.read<ManufacturerCubit>().getParticularAirbusDetail(
      context: context,
      query: widget.manufacturerDetailId,
    );
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.manufacturerDetailScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ManufacturerCubit, ManufacturerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final detail = state.manufacturerDetail?.data;
        if (detail == null) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text("No data found")),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: detail.general.companyName,
            centerTitle: false,
            leftButton: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.backArrowButton),
                fit: BoxFit.cover,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            rightButton: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.homeRightSetting),
                width: 35,
                height: 31,
                fit: BoxFit.cover,
              ),
              onPressed: () async {
                AppNavigator.push(
                  context,
                  SettingScreen(),
                  disableSwipeBack: true,
                );
              },
            ),
          ),

          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1500),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _buildImageCoverScroller(
                          screenHeight,
                          detail.general.coverPhoto,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (kIsWeb)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.grey.shade100,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          width: screenWidth * 0.03,

                                          height: screenWidth * 0.03,

                                          color: Colors.grey.shade200,
                                          child: Builder(
                                            builder: (context) {
                                              final logoUrl =
                                                  '${detail.general.logo}?v=${DateTime.now().millisecondsSinceEpoch}';
                                              final isSvg = detail.general.logo
                                                  .contains(".svg");
                                              final isAsset = detail
                                                  .general
                                                  .logo
                                                  .contains("assets");

                                              if (isAsset) {
                                                return Image.asset(
                                                  detail.general.logo,
                                                  width: screenWidth * 0.06,
                                                  height: screenWidth * 0.06,
                                                  fit: BoxFit.cover,
                                                );
                                              } else {
                                                return isSvg
                                                    ? SvgPicture.network(
                                                        logoUrl,
                                                        fit: BoxFit.contain,
                                                        placeholderBuilder:
                                                            (
                                                              context,
                                                            ) => SvgPicture.asset(
                                                              CommonUi.setSvgImage(
                                                                AssetsPath
                                                                    .manufacturerPlaceholder,
                                                              ),
                                                              height: 10,
                                                              width: 10,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                      )
                                                    : Image.network(
                                                        logoUrl,
                                                        width:
                                                            screenWidth * 0.06,
                                                        height:
                                                            screenWidth * 0.06,
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (_, _, _) =>
                                                            SvgPicture.asset(
                                                              CommonUi.setSvgImage(
                                                                AssetsPath
                                                                    .manufacturerPlaceholder,
                                                              ),
                                                              height: 10,
                                                              width: 10,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                      );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 60),
                                    CustomHeaderViewExpandable(
                                      isNeedToShowLeftRightBottomBorder: true,
                                      isNeedToShowLeftImage: true,
                                      fontStyle: AppTextStyles.regular(18.67)
                                          .copyWith(
                                            height: 1.0,
                                            color: AppColors.white,
                                          ),
                                      isLeftImage: IconButton(
                                        icon: SvgPicture.asset(
                                          CommonUi.setSvgImage(
                                            AssetsPath.aeroplaneManufacturer,
                                          ),
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                        onPressed: () async {},
                                      ),
                                      title: "List of all models",
                                      headerColor: AppColors.primaryDark,
                                      arrowBackgroundColor:
                                          AppColors.extraDarkYellow,
                                      arrowFrontColor: Colors.black,
                                      isExpandedViewAvailable: true,
                                      isExpanded: false,
                                      onHeaderTap: () {
                                        AppNavigator.push(
                                          context,
                                          AllPlanesListScreen(
                                            selectedAirbusId: detail.id,
                                            manufacturerName:
                                                detail.general.companyName,
                                          ),
                                          disableSwipeBack: true,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            _buildSectionHeader(
                              title: "GENERAL INFORMATION",
                              isExpanded: showMoreGeneralInfo,
                              onTap: () => setState(
                                () =>
                                    showMoreGeneralInfo = !showMoreGeneralInfo,
                              ),
                              isShowMoreLessOption:
                                  ((detail.general.description?.length ?? 0) >
                                  100),
                            ),

                            showMoreGeneralInfo
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    child: _buildGeneralInfo(detail.general),
                                  )
                                : const SizedBox.shrink(),

                            // Divider(
                            //   height: 0,
                            //   color: AppColors.separatorColourAppBar,
                            //   thickness: 3,
                            // ),
                            _buildSectionHeader(
                              title: "ABOUT THE COMPANY",
                              isExpanded: showMoreAboutInfo,
                              onTap: () => setState(
                                () => showMoreAboutInfo = !showMoreAboutInfo,
                              ),
                              isShowMoreLessOption:
                                  detail.company.companyDescription.length >
                                  100,
                            ),

                            if (showMoreAboutInfo)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detail.company.companyDescription,
                                      style: AppTextStyles.regular(16).copyWith(
                                        height: 1.5,
                                        color: AppColors.textColour,
                                      ),
                                      maxLines: showMoreAboutInfo ? null : 2,
                                      overflow: showMoreAboutInfo
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),

                            // Divider(
                            //   height: 0,
                            //   color: AppColors.separatorColourAppBar,
                            //   thickness: 3,
                            // ),
                            _buildSectionHeader(
                              title: "HISTORY",
                              isExpanded: showMoreHistory,
                              onTap: () => setState(
                                () => showMoreHistory = !showMoreHistory,
                              ),
                              isShowMoreLessOption:
                                  detail.company.companyHistory.isNotEmpty,
                            ),

                            if (showMoreHistory)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detail.company.companyHistory,
                                      style: AppTextStyles.regular(16).copyWith(
                                        height: 1.5,
                                        color: AppColors.textColour,
                                      ),
                                      maxLines: showMoreHistory ? null : 2,
                                      overflow: showMoreHistory
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),

                            // Divider(
                            //   height: 0,
                            //   color: AppColors.separatorColourAppBar,
                            //   thickness: 3,
                            // ),
                            if (detail.product.isNotEmpty)
                              _buildSectionHeader(
                                title: "PRODUCTS",
                                isExpanded: showMoreProducts,
                                onTap: () => setState(
                                  () => showMoreProducts = !showMoreProducts,
                                ),
                                isShowMoreLessOption: detail.product.isNotEmpty,
                              ),

                            if (showMoreProducts)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: List.generate(detail.product.length, (
                                    index,
                                  ) {
                                    final product = detail.product[index];
                                    final isExpanded = expandedIndex == index;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.06,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  expandedIndex = isExpanded
                                                      ? -1
                                                      : index;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 14,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: AppColors
                                                                .primaryBlue,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        product.series,
                                                        style:
                                                            AppTextStyles.bold(
                                                              16,
                                                            ).copyWith(
                                                              color: AppColors
                                                                  .black,
                                                            ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      isExpanded
                                                          ? Icons.remove
                                                          : Icons.add,
                                                      color:
                                                          AppColors.grayMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (isExpanded)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                                child: Divider(
                                                  thickness: 1.2,
                                                  color: AppColors
                                                      .separatorColourAppBar,
                                                ),
                                              ),
                                            if (isExpanded)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      16,
                                                      8,
                                                      16,
                                                      12,
                                                    ),
                                                child: Column(
                                                  children: List.generate(product.description.length, (
                                                    i,
                                                  ) {
                                                    final item =
                                                        product.description[i];

                                                    final data =
                                                        splitAircraftName(item);

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              data["title"] ??
                                                                  "",
                                                              style:
                                                                  AppTextStyles.regular(
                                                                    16,
                                                                  ).copyWith(
                                                                    color: AppColors
                                                                        .black,
                                                                  ),
                                                            ),
                                                          ),

                                                          if ((data["code"] ??
                                                                  "")
                                                              .isNotEmpty)
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 5,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .backgroundColourForManufacturer,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                data["code"] ??
                                                                    "",
                                                                style:
                                                                    AppTextStyles.regular(
                                                                      16,
                                                                    ).copyWith(
                                                                      color: AppColors
                                                                          .lightGreyBackgroundColour,
                                                                    ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            _buildSectionHeader(
                              title: "INTERESTING FACTS",
                              isExpanded: showInterestingFacts,
                              onTap: () => setState(() {
                                showInterestingFacts = !showInterestingFacts;
                              }),
                              isShowMoreLessOption:
                                  (detail.interestingFacts?.length ?? 0) > 0,
                            ),
                            const SizedBox(height: 10),
                            if (showInterestingFacts)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: (0.09),
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      showInterestingFacts
                                          ? (detail.interestingFacts?.length ??
                                                0)
                                          : (detail.interestingFacts?.length ??
                                                    0)
                                                .clamp(0, 2),
                                      (index) {
                                        final fact =
                                            detail.interestingFacts?[index] ??
                                            "";

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 14,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Icon(
                                                  Icons.double_arrow_outlined,
                                                  color: Colors.amber,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  fact,
                                                  style:
                                                      AppTextStyles.regular(
                                                        14,
                                                      ).copyWith(
                                                        height: 1.5,
                                                        color: AppColors
                                                            .greyForTextfield,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                    if (kIsWeb == false)
                      Positioned(
                        top: screenHeight * 0.21,
                        left: screenWidth * 0.06,
                        child: ClipOval(
                          child: Container(
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.22,
                            color: Colors.grey.shade200,
                            child: Builder(
                              builder: (context) {
                                final logoUrl =
                                    '${detail.general.logo}?v=${DateTime.now().millisecondsSinceEpoch}';
                                debugPrint(logoUrl);

                                final isSvg = detail.general.logo.contains(
                                  ".svg",
                                );
                                final isAsset = detail.general.logo.contains(
                                  "assets",
                                );

                                if (isAsset) {
                                  return Image.asset(
                                    detail.general.logo,
                                    width: screenWidth * 0.22,
                                    height: screenWidth * 0.22,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return isSvg
                                      ? SvgPicture.network(
                                          logoUrl,
                                          fit: BoxFit.contain,
                                          placeholderBuilder: (context) =>
                                              SvgPicture.asset(
                                                CommonUi.setSvgImage(
                                                  AssetsPath.manufacturerPlaceholder,
                                                ),
                                                height: 10,
                                                width: 10,
                                                fit: BoxFit.contain,
                                              ),
                                        )
                                      : Image.network(
                                          logoUrl,
                                          width: screenWidth * 0.22,
                                          height: screenWidth * 0.22,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, _, _) =>
                                              SvgPicture.asset(
                                                CommonUi.setSvgImage(
                                                  AssetsPath.manufacturerPlaceholder,
                                                ),
                                                height: 10,
                                                width: 10,
                                                fit: BoxFit.contain,
                                              ),
                                        );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralInfo(General generalDetails) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: customField(
                label: 'Headquarters',
                text: generalDetails.headquarter ?? '',
                fontSize: 18,
                labelColor: AppColors.lightGreyTextFieldHeading,
                textColor: AppColors.primaryValueColour,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: customField(
                label: 'Founding Date',
                text: generalDetails.foundingDate,
                fontSize: 18,
                labelColor: AppColors.lightGreyTextFieldHeading,
                textColor: AppColors.primaryValueColour,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required bool isShowMoreLessOption,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: GestureDetector(
            onTap: isShowMoreLessOption == true ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyles.bold(20).copyWith(
                        height: 1.0,
                        color: AppColors.primaryValueColour,
                      ),
                    ),
                  ),
                  if (isShowMoreLessOption)
                    GestureDetector(
                      onTap: onTap,
                      child: Row(
                        children: [
                          // Text(
                          //   isExpanded ? "Show Less" : "Show More",
                          //   style: const TextStyle(fontSize: 13),
                          // ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        Divider(
          height: 0,
          color: AppColors.separatorColourAppBar,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        SizedBox(
          height:
              (showMoreGeneralInfo ||
                  showMoreAboutInfo ||
                  showMoreHistory ||
                  showMoreProducts ||
                  showInterestingFacts)
              ? 10
              : 30,
        ),
      ],
    );
  }

  Widget _buildImageCoverScroller(double screenHeight, CoverPhoto coverImages) {
    final image = ClipRRect(
      child: Image.network(
        coverImages.url,
        width: MediaQuery.of(context).size.width,
        height: screenHeight * 0.30,
        fit: BoxFit.cover,
      ),
    );

    return SizedBox(
      height: screenHeight * 0.26,
      width: double.infinity,
      child: Stack(
        children: [
          image,
          // Show author only if wiki exists AND author is not null/empty
          if ((coverImages.wiki?.isNotEmpty ?? false) &&
              (coverImages.author?.isNotEmpty ?? false))
            Positioned(
              right: 8,
              bottom: 8,
              child: GestureDetector(
                onTap: () async {
                  final uri = Uri.tryParse(coverImages.wiki!);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open URL.')),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: ((0.6))),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '© ${coverImages.author}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
