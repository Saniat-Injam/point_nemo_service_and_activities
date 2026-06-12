import 'dart:async';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/controllers/search_and_filter_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_activities_controller.dart';

/// Maps the human-readable category label (passed as Get.arguments from
/// ActivityGrid) to the API `type` enum value.
const _categoryToApiType = {
  'Rent Boat': 'BOAT_RENTAL',
  'Water Sports': 'WATER_SPORTS',
  'Dive & Snorkel': 'DIVING_COURSE',
  'Fishing Trip': 'FISHING_TRIP',
};

class ServiceController extends GetxController {
  final _networkCaller = NetworkCaller();

  final RxString categoryTitle = ''.obs;
  final RxList<ServiceModel> servicesList = <ServiceModel>[].obs;
  final isLoading = false.obs;

  // Pagination
  int _currentPage = 1;
  static const int _limit = 10;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  // Search
  late final searchAndFilterController = SearchAndFilterController(
    onSearch: (_) => fetchServices(),
  );

  String _apiType = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String) {
      categoryTitle.value = args;
      _apiType = _categoryToApiType[args] ?? '';
      if (_apiType.isNotEmpty) {
        fetchServices();
      }
    }
  }

  @override
  void onClose() {
    searchAndFilterController.dispose();
    super.onClose();
  }



  String _buildUrl(int page) {
    final params = StringBuffer('${AppUrls.getAllServices}?page=$page&limit=$_limit&type=$_apiType');
    final q = searchAndFilterController.searchQuery.value;
    if (q.isNotEmpty) params.write('&search=${Uri.encodeComponent(q)}');
    return params.toString();
  }

  Future<void> fetchServices() async {
    _currentPage = 1;
    hasMore.value = true;
    servicesList.clear();
    isLoading.value = true;

    final url = _buildUrl(_currentPage);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = ServiceMetaModel.fromJson(data['meta']);
      servicesList.assignAll(
        rawList.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> fetchMoreServices() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url = _buildUrl(nextPage);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = ServiceMetaModel.fromJson(data['meta']);
      servicesList.addAll(
        rawList.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  Future<void> toggleFavorite(String serviceId) async {
    final index = servicesList.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      final isNowFavorite = !servicesList[index].isFavorite;
      servicesList[index].isFavorite = isNowFavorite;
      servicesList.refresh();

      final String url = AppUrls.toggleFavorite(serviceId);
      final response = isNowFavorite
          ? await _networkCaller.postRequest(url, body: {})
          : await _networkCaller.deleteRequest(url, null);

      if (!response.isSuccess) {
        servicesList[index].isFavorite = !isNowFavorite;
        servicesList.refresh();
        AppHelperFunctions.showSnackBar(response.errorMessage);
      } else {
        // Sync with other controllers on success
        _syncWithOthers(serviceId, isNowFavorite);
      }
    }
  }

  /// Synchronizes favorite status from other screens (e.g. Favorite Screen)
  void updateFavoriteStatus(String serviceId, bool isFavorite) {
    final int index = servicesList.indexWhere((e) => e.id == serviceId);
    if (index != -1) {
      servicesList[index].isFavorite = isFavorite;
      servicesList.refresh();
    }
  }

  void _syncWithOthers(String serviceId, bool isFavorite) {
    if (Get.isRegistered<FeaturedCoursesController>()) {
      Get.find<FeaturedCoursesController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
    if (Get.isRegistered<FeaturedActivitiesController>()) {
      Get.find<FeaturedActivitiesController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
  }
}

