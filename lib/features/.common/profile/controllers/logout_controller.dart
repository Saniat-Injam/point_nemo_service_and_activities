import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';

class LogoutController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = false.obs;

  /// Calls [POST /auth/logout], clears local storage, then navigates away.
  /// Works for all three roles: User, Business Owner, Captain.
  Future<void> logout() async {
    isLoading.value = true;

    final String? refreshToken = StorageService.refreshToken;

    final response = await _networkCaller.postRequest(
      AppUrls.logout,
      body: (refreshToken != null && refreshToken.isNotEmpty)
          ? {'refreshToken': refreshToken}
          : {},
    );

    if (response.isSuccess) {
      // Clear all local auth data and redirect to role selection
      await StorageService.logoutUser();
    } else {
      // Even if the server-side logout fails, clear local data so the user
      // is not stuck — then still redirect.
      AppHelperFunctions.showSnackBar(
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Logout failed. Please try again.',
      );
      await StorageService.logoutUser();
    }

    isLoading.value = false;
  }
}


