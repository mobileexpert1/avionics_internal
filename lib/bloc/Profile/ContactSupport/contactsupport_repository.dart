import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'contactsupport_model.dart';

class ContactSupportRepository {
  Future<void> submitContactSupport(ContactSupportModel contact) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.contactSupport,
    );
    try {
      await ApiService.post(url: url, body: contact.toJson());
    } catch (e) {
      throw e.toString();
    }
  }
}
