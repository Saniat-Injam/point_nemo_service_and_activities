import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/chat_model.dart';

class ChatController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = false.obs;
  final RxList<ChatModel> chats = <ChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    final response =
        await _networkCaller.getRequest(AppUrls.getConversations);
    if (response.isSuccess) {
      final outer = response.responseData['data'];
      final List rawList = (outer is Map ? outer['data'] : []) as List? ?? [];
      chats.value =
          rawList.map((e) => ChatModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }
    isLoading.value = false;
  }
}
