import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_model.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_model.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../home/manufacturer/Manufacturer_detail_model.dart';

class AllPlanesState {
  final List<AircraftListModel> listoFAircraftModels;
  final ManufacturerDetailResponse? manufacturerDetail;
  final bool isLoading;
  final bool isFetchingMore;
  final int currentPage;
  final bool hasNextPage;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;
  final List<FlightModel>? flights;
  final String currentQuery;


  const AllPlanesState({
    required this.listoFAircraftModels,
    this.manufacturerDetail,
    this.isLoading = false,
    this.isFetchingMore = false,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
    this.flights,
    this.currentQuery = '',
  });

  AllPlanesState copyWith({
    List<AircraftListModel>? listoFAircraftModels,
    ManufacturerDetailResponse? manufacturerDetail,
    bool? isLoading,
    bool? isFetchingMore,
    int? currentPage,
    bool? hasNextPage,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
    List<FlightModel>? flights,
    String? currentQuery,
  }) {
    return AllPlanesState(
      listoFAircraftModels: listoFAircraftModels ?? this.listoFAircraftModels,
      manufacturerDetail: manufacturerDetail ?? this.manufacturerDetail,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      flights: flights ?? this.flights,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}
