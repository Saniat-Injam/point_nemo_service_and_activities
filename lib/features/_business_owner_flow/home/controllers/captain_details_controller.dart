import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/captain_model.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/review_model.dart';

class CaptainDetailsController extends GetxController {
  final _networkCaller = NetworkCaller();
  final captain = Rxn<CaptainModel>();

  final RxList<ServiceReviewModel> reviews = <ServiceReviewModel>[].obs;
  final RxBool isLoadingReviews = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is CaptainModel) {
      captain.value = Get.arguments as CaptainModel;
      loadReviews(captain.value!.id);
    }
  }

  void setCaptain(CaptainModel? value) {
    if (captain.value?.id != value?.id) {
      captain.value = value;
      if (value != null) {
        loadReviews(value.id);
      }
    } else {
      captain.value = value;
    }
  }

  Future<void> loadReviews(String captainId) async {
    isLoadingReviews.value = true;
    final response = await _networkCaller.getRequest(
      AppUrls.getCaptainReviews(captainId, 1, 10),
    );

    if (response.isSuccess) {
      final List data = response.responseData['data']['data'] ?? [];
      reviews.value = data.map((e) => ServiceReviewModel.fromJson(e)).toList();
    }
    isLoadingReviews.value = false;
  }
}
