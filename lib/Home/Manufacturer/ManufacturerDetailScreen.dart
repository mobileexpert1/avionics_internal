import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Helpers/Custom_widget.dart';
import '../../bloc/manufacturer/Manufacturer_detail_model.dart';
import '../../bloc/manufacturer/manufacturer_cubit.dart';
import '../../bloc/manufacturer/manufacturer_state.dart';
import '../AllPlaneListAndDetails/AllPlaneListScreen.dart';

class ManufacturerDetailScreen extends StatefulWidget {
  final String manufacturerDetailId;

  const ManufacturerDetailScreen({Key? key, required this.manufacturerDetailId})
    : super(key: key);

  @override
  State<ManufacturerDetailScreen> createState() => _AirbusScreenState();
}

class _AirbusScreenState extends State<ManufacturerDetailScreen> {
  bool showMoreGeneralInfo = true;
  bool showMoreAboutInfo = false;
  bool showMoreHistory = false;
  bool showMoreProducts = false;

  @override
  void initState() {
    super.initState();
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
        final detail = state.manufacturerDetail?.data;

        return detail == null
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
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
                                      const SizedBox(height: 4),
                                      Text(
                                        detail.general.description,
                                        style: TextStyle(fontSize: 14),
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
                                      builder: (_) =>
                                          const AllPlanesListScreen(),
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
                                  () => showMoreGeneralInfo =
                                      !showMoreGeneralInfo,
                                ),
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

                              // Image Scroller (only shown when expanded)
                              _buildImageGalleryScroller(detail.general.gallery),

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
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    detail.product?.length ?? 0,
                                        (index) {
                                      final product = detail.product![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.series ?? '',
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              product.description ?? '',
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
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
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
                      Positioned(
                        top: screenHeight * 0.21,
                        left: screenWidth * 0.06,
                        child: ClipOval(
                          child:Image.network(
                        ApiImageBaseUrlConstant.imageAirPlaneBaseUrl +
                        detail.general.logo,
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.22,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
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
              child: customField(label: 'CEO', text: generalDetails.ceo ?? ''),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: customField(
                label: 'Founding Date',
                text: generalDetails.foundingDate ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: customField(
                label: 'Last year revenue',
                text: generalDetails.lastYearRevenue ?? '',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(title)),
                  Row(
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

  Widget _buildImageCoverScroller(
    double screenHeight,
    List<String> coverImages,
  ) {
    return SizedBox(
      height: screenHeight * 0.26,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coverImages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ClipRRect(
            child: Image.network(
              ApiImageBaseUrlConstant.imageAirPlaneBaseUrl + coverImages[index],
              width: MediaQuery.of(context).size.width,
              height: screenHeight * 0.26,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageGalleryScroller(List<String> galleryImages) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: galleryImages.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(right: index == 2 ? 0 : 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ApiImageBaseUrlConstant.imageAirPlaneBaseUrl +
                    galleryImages[index],
                width: 300,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
