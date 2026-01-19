// import 'package:avionics_internal/bloc/MapSection/flight_map_model.dart';
// import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main() {
//   final FlightRepository repository = FlightRepository();
//
//   group('FLIGHT REPOSITORY API REAL SERVER TEST', () {
//     test(
//       'Fetch Live Flights → API → STATUS & DATA CHECK',
//           () async {
//         const String bounds = "90,-90,-180,180";
//
//         final flights = await repository.getFlights(
//           bounds: bounds,
//           limit: 5,
//         );
//
//         print("✈️ TOTAL FLIGHTS FETCHED 👉 ${flights.length}");
//
//         expect(flights, isA<List<FlightModel>>());
//
//         if (flights.isNotEmpty) {
//           final flight = flights.first;
//
//           expect(flight.id, isNotEmpty);
//           expect(flight.latitude, isA<double>());
//           expect(flight.longitude, isA<double>());
//         }
//       },
//     );
//
//     test(
//       'Fetch Particular Flight Details → API → RESPONSE CHECK',
//           () async {
//         const String flightId = "3dca7e6d";
//
//         try {
//           final response =
//           await repository.getParticularFlightDetails(
//             flightId: flightId,
//           );
//
//           expect(response, isNotNull);
//           expect(response.flights, isA<List>());
//         } catch (e) {
//           expect(e, isNotNull);
//         }
//       },
//     );
//
//     test(
//       'Fetch Map Key Values From Server → API → SUCCESS',
//           () async {
//         final keyValues =
//         await repository.getMapKeyValueFromServer();
//
//         expect(keyValues, isNotNull);
//         expect(keyValues.data, isNotNull);
//       },
//     );
//   });
// }
