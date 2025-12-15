import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'Manufacturer_detail_model.dart';
import 'manufacturer_list_model.dart';

class ManufacturerState {
  final List<ManufacturerListModel> manufacturers;
  final ManufacturerDetailResponse? manufacturerDetail;
  final bool isLoading;
  final bool isFetchingMore;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  const ManufacturerState({
    required this.manufacturers,
    this.manufacturerDetail,
    this.isLoading = false,
    this.isFetchingMore = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasNextPage = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ManufacturerState copyWith({
    List<ManufacturerListModel>? manufacturers,
    ManufacturerDetailResponse? manufacturerDetail,
    bool? isLoading,
    bool? isFetchingMore,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ManufacturerState(
      manufacturers: manufacturers ?? this.manufacturers,
      manufacturerDetail: manufacturerDetail ?? this.manufacturerDetail,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
