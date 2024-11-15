import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';

class ResponseErrorUtil {
  ResponseErrorUtil._();
  static void handleErrorResponse(BaseController controller, int statusCode) {
    if (statusCode == 500) {
      controller.viewState.value = ViewState.noInternetConnection;
    } else if (statusCode == 408) {
      controller.viewState.value = ViewState.timeout;
    } else if (statusCode == 1000 || statusCode > 500) {
      controller.viewState.value = ViewState.serverError;
    } else if (statusCode >= 300) {
      controller.viewState.value = ViewState.notFound;
    }
  }
}
