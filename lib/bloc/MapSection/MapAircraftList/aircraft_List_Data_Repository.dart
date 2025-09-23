import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';
import 'aircraft_List_Data_State.dart';

class AircraftListDataRepository {
  // Existing method
  Future<AircraftListResponse> getListOfAllPlanes({
    required List<String> aircraftIds,
  }) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiFunctionUrlMapSecitonConstant.aircraftFlyingList}",
    );

    try {
      final jsonData =
          await ApiService.post(url: url, body: {"aircraft_id": aircraftIds})
              as Map<String, dynamic>;
      return AircraftListResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getAirportList() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return [
        {
          "airport_name": "Hartsfield Jackson Atlanta International Airport",
          "icao": "KATL",
          "city": "Atlanta",
          "country": "United States",
          "latitude": 33.6367,
          "longitude": -84.4281,
        },
        {
          "airport_name": "Heathrow Airport",
          "icao": "EGLL",
          "city": "London",
          "country": "United Kingdom",
          "latitude": 51.4706,
          "longitude": -0.4619,
        },
        {
          "airport_name": "Dubai International Airport",
          "icao": "OMDB",
          "city": "Dubai",
          "country": "United Arab Emirates",
          "latitude": 25.2528,
          "longitude": 55.3644,
        },
        {
          "airport_name": "Indira Gandhi International Airport",
          "icao": "VIDP",
          "city": "New Delhi",
          "country": "India",
          "latitude": 28.5562,
          "longitude": 77.1000,
        },
        {
          "airport_name": "Los Angeles International Airport",
          "icao": "KLAX",
          "city": "Los Angeles",
          "country": "United States",
          "latitude": 33.941588,
          "longitude": -118.40853,
        },
        {
          "airport_name": "Tokyo Haneda Airport",
          "icao": "RJTT",
          "city": "Tokyo",
          "country": "Japan",
          "latitude": 35.5523,
          "longitude": 139.7798,
        },
        {
          "airport_name": "Singapore Changi Airport",
          "icao": "WSSS",
          "city": "Singapore",
          "country": "Singapore",
          "latitude": 1.3644,
          "longitude": 103.9915,
        },
        {
          "airport_name": "Frankfurt am Main Airport",
          "icao": "EDDF",
          "city": "Frankfurt",
          "country": "Germany",
          "latitude": 50.0379,
          "longitude": 8.5622,
        },
        {
          "airport_name": "Sydney Kingsford Smith Airport",
          "icao": "YSSY",
          "city": "Sydney",
          "country": "Australia",
          "latitude": -33.9461,
          "longitude": 151.1772,
        },
        {
          "airport_name": "Toronto Pearson International Airport",
          "icao": "CYYZ",
          "city": "Toronto",
          "country": "Canada",
          "latitude": 43.6777,
          "longitude": -79.6248,
        },
        {
          "airport_name": "John F. Kennedy International Airport",
          "icao": "KJFK",
          "city": "New York",
          "country": "United States",
          "latitude": 40.641766,
          "longitude": -73.780968,
        },
        {
          "airport_name": "Incheon International Airport",
          "icao": "RKSI",
          "city": "Seoul",
          "country": "South Korea",
          "latitude": 37.460190,
          "longitude": 126.440696,
        },
        {
          "airport_name": "Istanbul Airport",
          "icao": "LTFM",
          "city": "Istanbul",
          "country": "Turkey",
          "latitude": 41.2752778,
          "longitude": 28.7519444,
        },
        {
          "airport_name": "Paris Charles de Gaulle Airport",
          "icao": "LFPG",
          "city": "Paris",
          "country": "France",
          "latitude": 49.0097222,
          "longitude": 2.5486111,
        },
        {
          "airport_name": "Narita International Airport",
          "icao": "RJAA",
          "city": "Tokyo",
          "country": "Japan",
          "latitude": 35.764722,
          "longitude": 140.386389,
        },
        {
          "airport_name": "Cochin International Airport",
          "icao": "VOCI",
          "city": "Kochi",
          "country": "India",
          "latitude": 10.151994,
          "longitude": 76.401906,
        },
        {
          "airport_name": "Coimbatore International Airport",
          "icao": "VOCB",
          "city": "Coimbatore",
          "country": "India",
          "latitude": 11.0299997,
          "longitude": 77.0434036,
        },
        {
          "airport_name": "Thiruvananthapuram International Airport",
          "icao": "VOTV",
          "city": "Thiruvananthapuram",
          "country": "India",
          "latitude": 8.482778,
          "longitude": 76.921389,
        },
        {
          "airport_name": "Dr. Babasaheb Ambedkar International Airport",
          "icao": "VANP",
          "city": "Nagpur",
          "country": "India",
          "latitude": 21.0910,
          "longitude": 79.0478,
        },
      ];
    } catch (e) {
      throw e.toString();
    }
  }
}
