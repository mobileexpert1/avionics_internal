import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackBox_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/AppColors.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/Custom_widget.dart';
import '../../../bloc/Home/manufacturer/Manufacturer_detail_model.dart';
import '../../../bloc/Home/manufacturer/manufacturer_cubit.dart';
import '../../../bloc/Home/manufacturer/manufacturer_state.dart';
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

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ManufacturerCubit>();
    cubit.emit(cubit.state.copyWith(manufacturerDetail: null, isLoading: true));

    context.read<ManufacturerCubit>().getParticularAirbusDetail(
      context: context,
      query: widget.manufacturerDetailId,
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
          appBar: kIsWeb
              ? CustomAppBar(
                  title: "",
                  leftButton: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1500),
              // Web max width
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
                                                                    .manuFirstImage,
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
                                                                    .manuFirstImage,
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

                                      // --- TITLE + SUBTITLE ---
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              detail.general.companyName,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!kIsWeb)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.grey.shade100,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 8,
                                  ), // Internal padding
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 45),
                                      Text(
                                        detail.general.companyName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),

                            // All List Of Airplane
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AllPlanesListScreen(
                                      selectedAirbusId: detail.id,
                                      manufacturerName:
                                          detail.general.companyName,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 5,
                                ),

                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      CommonUi.setSvgImage(AssetsPath.Plane1),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        "List of All Planes",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            const Divider(
                              height: 0,
                              thickness: 3,
                              color: AppColors.sepratorColourAppBar,
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
                            Divider(
                              height: 0,
                              color: AppColors.sepratorColourAppBar,
                              thickness: 3,
                            ),

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

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.company.companyDescription,
                                    style: const TextStyle(height: 1.5),
                                    maxLines: showMoreAboutInfo ? null : 2,
                                    // null = show full text
                                    overflow: showMoreAboutInfo
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),

                            Divider(
                              height: 0,
                              color: AppColors.sepratorColourAppBar,
                              thickness: 3,
                            ),

                            _buildSectionHeader(
                              title: "HISTORY",
                              isExpanded: showMoreHistory,
                              onTap: () => setState(
                                () => showMoreHistory = !showMoreHistory,
                              ),
                              isShowMoreLessOption:
                                  detail.company.companyHistory.length > 100,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.company.companyHistory,
                                    style: const TextStyle(height: 1.5),
                                    maxLines: showMoreHistory ? null : 2,
                                    overflow: showMoreHistory
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),

                            Divider(
                              height: 0,
                              color: AppColors.sepratorColourAppBar,
                              thickness: 3,
                            ),

                            _buildSectionHeader(
                              title: "PRODUCTS",
                              isExpanded: showMoreProducts,
                              onTap: () => setState(
                                () => showMoreProducts = !showMoreProducts,
                              ),
                              isShowMoreLessOption: detail.product.length > 2,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(detail.product.length, (
                                  index,
                                ) {
                                  final product = detail.product[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.series,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product.description,
                                          style: const TextStyle(height: 1.5),
                                          maxLines: showMoreProducts ? null : 2,
                                          overflow: showMoreProducts
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                      ],
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
                                  (detail.interestingFacts?.length ?? 0) > 2,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(
                                  // show 2 facts by default, full list if expanded
                                  showInterestingFacts
                                      ? (detail.interestingFacts?.length ?? 0)
                                      : (detail.interestingFacts?.length ?? 0)
                                            .clamp(0, 1),
                                  (index) {
                                    final fact =
                                        detail.interestingFacts?[index] ?? "";
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "• $fact",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),
                                    );
                                  },
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
                        top: screenHeight * 0.06,
                        left: screenWidth * 0.05,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    // Positioned(
                    //   top: screenHeight * 0.21,
                    //   left: screenWidth * 0.06,
                    //   child: ClipOval(
                    //     child: Container(
                    //       width: screenWidth * 0.22,
                    //       height: screenWidth * 0.22,
                    //       color:
                    //           Colors.grey.shade200, // Background circle color
                    //       child: Builder(
                    //         builder: (context) {
                    //           final logoUrl =
                    //               '${detail.general.logo}?v=${DateTime.now().millisecondsSinceEpoch}';
                    //           debugPrint(logoUrl);
                    //
                    //           final isSvg = detail.general.logo.contains(
                    //             ".svg",
                    //           );
                    //           final isAsset = detail.general.logo.contains(
                    //             "assets",
                    //           );
                    //
                    //           if (isAsset) {
                    //             return Image.asset(
                    //               detail.general.logo,
                    //               width: screenWidth * 0.22,
                    //               height: screenWidth * 0.22,
                    //               fit: BoxFit.cover,
                    //             );
                    //           } else {
                    //             return isSvg
                    //                 ? SvgPicture.network(
                    //                     logoUrl,
                    //                     fit: BoxFit.contain,
                    //                     placeholderBuilder: (context) =>
                    //                         SvgPicture.asset(
                    //                           CommonUi.setSvgImage(
                    //                             AssetsPath.manuFirstImage,
                    //                           ),
                    //                           height: 10,
                    //                           width: 10,
                    //                           fit: BoxFit.contain,
                    //                         ),
                    //                   )
                    //                 : Image.network(
                    //                     logoUrl,
                    //                     width: screenWidth * 0.22,
                    //                     height: screenWidth * 0.22,
                    //                     fit: BoxFit.contain,
                    //                     errorBuilder: (_, _, _) =>
                    //                         SvgPicture.asset(
                    //                           CommonUi.setSvgImage(
                    //                             AssetsPath.manuFirstImage,
                    //                           ),
                    //                           height: 10,
                    //                           width: 10,
                    //                           fit: BoxFit.contain,
                    //                         ),
                    //                   );
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: customField(
                label: 'Founding Date',
                text: generalDetails.foundingDate,
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
                  Flexible(child: Text(title)),
                  if (isShowMoreLessOption)
                    GestureDetector(
                      onTap: onTap,
                      child: Row(
                        children: [
                          Text(
                            isExpanded ? "Show Less" : "Show More",
                            style: const TextStyle(fontSize: 13),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
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
          color: AppColors.sepratorColourAppBar,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(height: 20),
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
                    color: Colors.black.withOpacity(0.6),
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
