import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/review_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_activities_controller.dart';

class ServiceDetailsController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final Rx<ServiceDetailModel?> serviceDetail = Rx<ServiceDetailModel?>(null);
  final RxSet<String> selectedAddons = <String>{}.obs;

  final RxList<ServiceReviewModel> reviews = <ServiceReviewModel>[].obs;
  final RxBool isLoadingReviews = false.obs;

  /// Called once when the controller is created (per-navigation, not global).
  /// The service ID is expected as a String via [Get.arguments].
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      loadService(args);
    } else {
      // No valid args — stop loading to avoid permanent spinner
      isLoading.value = false;
    }
  }

  /// Public so the screen can call it for retry or forced refresh.
  Future<void> loadService(String serviceId) async {
    isLoading.value = true;
    serviceDetail.value = null;
    selectedAddons.clear();

    final response = await _networkCaller.getRequest(
      AppUrls.getServiceById(serviceId),
    );

    if (response.isSuccess) {
      final data = response.responseData['data'];
      serviceDetail.value = ServiceDetailModel.fromJson(
        data as Map<String, dynamic>,
      );
      
      loadReviews(serviceId);
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> loadReviews(String serviceId) async {
    isLoadingReviews.value = true;
    final response = await _networkCaller.getRequest(
      AppUrls.getServiceReviews(serviceId, 1, 10),
    );

    if (response.isSuccess) {
      final List data = response.responseData['data']['data'] ?? [];
      reviews.value = data.map((e) => ServiceReviewModel.fromJson(e)).toList();
    }
    isLoadingReviews.value = false;
  }

  void toggleAddon(String id) {
    if (selectedAddons.contains(id)) {
      selectedAddons.remove(id);
    } else {
      selectedAddons.add(id);
    }
  }

  Future<void> toggleFavorite() async {
    final service = serviceDetail.value;
    if (service != null) {
      final isNowFavorite = !service.isFavorite;
      service.isFavorite = isNowFavorite;
      serviceDetail.refresh();

      final String url = AppUrls.toggleFavorite(service.id);
      final response = isNowFavorite
          ? await _networkCaller.postRequest(url, body: {})
          : await _networkCaller.deleteRequest(url, null);

      if (!response.isSuccess) {
        service.isFavorite = !isNowFavorite;
        serviceDetail.refresh();
        AppHelperFunctions.showSnackBar(response.errorMessage);
      } else {
        if (Get.isRegistered<ServiceController>()) {
          Get.find<ServiceController>()
              .updateFavoriteStatus(service.id, service.isFavorite);
        }
        if (Get.isRegistered<FeaturedCoursesController>()) {
          Get.find<FeaturedCoursesController>()
              .updateFavoriteStatus(service.id, service.isFavorite);
        }
        if (Get.isRegistered<FeaturedActivitiesController>()) {
          Get.find<FeaturedActivitiesController>()
              .updateFavoriteStatus(service.id, service.isFavorite);
        }
      }
    }
  }
}

