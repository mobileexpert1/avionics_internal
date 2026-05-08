// import 'package:avionics_internal/bloc/Onboarding/Subscription/subscription_list_model.dart';
// import '../../../Constants/ApiClass/api_service.dart';
// import '../../../Constants/ApiClass/shared_prefs_helper.dart';
// import '../../../Constants/ConstantStrings.dart';
//
// class SubscriptionRepository {
//   Future<List<SubscriptionItemModel>> fetchSubscriptions() async {
//     final url = Uri.parse(
//       ApiBaseUrlConstant.baseUrl +
//           ApiFunctionUrlConstant.userService +
//           ApiServiceUrlConstant.getSubscritionList,
//     );
//
//     try {
//       final response = await ApiService.get(url: url);
//       final dataList = response['data'] as List;
//
//       return dataList
//           .map((jsonItem) => SubscriptionItemModel.fromJson(jsonItem))
//           .toList();
//     } catch (e) {
//       throw e.toString();
//     }
//   }
//
//   Future<SubscriptionItemModel> postSubscriptionApi({
//     required subscription_id,
//   }) async {
//     final userId = await SharedPrefsHelper.read();
//     if (userId == null) throw 'User not logged in.';
//     final url = Uri.parse(
//       ApiBaseUrlConstant.baseUrl +
//           ApiFunctionUrlConstant.userService +
//           ApiServiceUrlConstant.postSubscrition,
//     );
//
//     try {
//       final response = await ApiService.post(
//         url: url,
//         body: {"subscription_id": subscription_id,"current_user_id": userId},
//       );
//
//       return SubscriptionItemModel.fromJson(response);
//     } catch (e) {
//       throw e.toString();
//     }
//   }
// }
