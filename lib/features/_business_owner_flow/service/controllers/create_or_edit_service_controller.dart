import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_snackbar.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/controllers/business_owner_service_controller.dart';

class CreateServiceController extends GetxController {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final includedServiceController = TextEditingController();
  final descriptionController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  // Additional service popup controllers
  final additionalServiceNameController = TextEditingController();
  final additionalServicePriceController = TextEditingController();

  // Boat rental specific controllers
  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final lengthController = TextEditingController();

  final includedServices = <String>[].obs;
  final additionalServices = <Map<String, String>>[].obs;

  final isLoading = false.obs;
  String? editId;

  // Boat type (required for BOAT_RENTAL)
  final selectedBoatType = ''.obs;
  static const List<String> boatTypeLabels = [
    'Motorboat',
    'Catamaran',
    'RIB',
    'Jet Ski',
    'Gulet',
    'Houseboat',
  ];
  static const Map<String, String> boatTypeApiMap = {
    'Motorboat': 'MOTORBOAT',
    'Catamaran': 'CATAMARAN',
    'RIB': 'RIB',
    'Jet Ski': 'JET_SKI',
    'Gulet': 'GULET',
    'Houseboat': 'HOUSEBOAT',
  };

  final RxList<File> servicePhotos = <File>[].obs;
  final NetworkCaller _networkCaller = NetworkCaller();

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    priceController.dispose();
    includedServiceController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    additionalServiceNameController.dispose();
    additionalServicePriceController.dispose();
    modelController.dispose();
    capacityController.dispose();
    lengthController.dispose();
    super.onClose();
  }

  void clearData() {
    editId = null;
    nameController.clear();
    locationController.clear();
    priceController.clear();
    includedServiceController.clear();
    descriptionController.clear();
    startTimeController.clear();
    endTimeController.clear();
    additionalServiceNameController.clear();
    additionalServicePriceController.clear();
    modelController.clear();
    capacityController.clear();
    lengthController.clear();
    includedServices.clear();
    additionalServices.clear();
    selectedBoatType.value = '';
    servicePhotos.clear();
  }

  Future<void> loadDataForEdit(String serviceId) async {
    clearData();
    editId = serviceId;
    isLoading.value = true;
    final response = await _networkCaller.getRequest(AppUrls.getServiceById(serviceId));
    if (response.isSuccess) {
      final data = response.responseData['data'] ?? response.responseData;
      nameController.text = data['name'] ?? '';
      descriptionController.text = data['description'] ?? '';
      
      locationController.text = data['address'] ?? data['location']?['address'] ?? (data['location'] is String ? data['location'] : '');
      priceController.text = (data['price'] ?? 0).toString();
      startTimeController.text = data['dailyStartTime'] ?? '';
      endTimeController.text = data['dailyEndTime'] ?? '';
      
      final boatTypeRaw = data['boatType'] ?? data['boatRentalDetails']?['boatType'];
      if (boatTypeRaw != null) {
        final apiType = boatTypeRaw.toString().toUpperCase();
        for (var entry in boatTypeApiMap.entries) {
          if (entry.value == apiType) {
            selectedBoatType.value = entry.key;
            break;
          }
        }
        if (selectedBoatType.value.isEmpty) {
          selectedBoatType.value = boatTypeRaw;
        }
      }
      
      modelController.text = data['model'] ?? data['boatRentalDetails']?['model'] ?? '';
      capacityController.text = (data['capacity'] ?? data['boatRentalDetails']?['capacity'] ?? '').toString();
      lengthController.text = (data['length'] ?? data['boatRentalDetails']?['length'] ?? '').toString();
      
      if (data['additionalServices'] != null) {
        final List services = data['additionalServices'];
        additionalServices.value = services.map((s) => {
          'name': s['name']?.toString() ?? '',
          'price': s['price']?.toString() ?? '0',
          'description': s['description']?.toString() ?? '',
        }).toList();
      }
      
      if (data['includedServices'] != null) {
        final List services = data['includedServices'];
        includedServices.value = services.map((s) => s['description']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      }
    } else {
      CustomSnackBar.showError(message: response.errorMessage);
    }
    isLoading.value = false;
  }

  void addIncludedService() {
    if (includedServiceController.text.isNotEmpty) {
      includedServices.add(includedServiceController.text);
      includedServiceController.clear();
    }
  }

  void addAdditionalService() {
    if (additionalServiceNameController.text.isNotEmpty &&
        additionalServicePriceController.text.isNotEmpty) {
      additionalServices.add({
        'name': additionalServiceNameController.text,
        'price': additionalServicePriceController.text,
        'description': "Record your ride", // Or we could add a field for this, using default for now
      });
      additionalServiceNameController.clear();
      additionalServicePriceController.clear();
    }
  }

  Future<void> pickServicePhotos() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var img in images) {
        if (servicePhotos.length < 3) {
          servicePhotos.add(File(img.path));
        }
      }
    }
  }

  Future<void> takeServicePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null && servicePhotos.length < 3) {
      servicePhotos.add(File(image.path));
    }
  }

  String formatTime(String time) {
    if (time.isEmpty) return "09:00";
    if (time.contains(':')) {
      final parts = time.split(':');
      final hour = parts[0].padLeft(2, '0');
      // For AM/PM removal if needed, but the original might just contain HH:MM
      if (parts[1].contains(' ')) {
        final subParts = parts[1].split(' ');
        var parsedHour = int.parse(hour);
        if (subParts[1].toUpperCase() == 'PM' && parsedHour != 12) {
          parsedHour += 12;
        } else if (subParts[1].toUpperCase() == 'AM' && parsedHour == 12) {
          parsedHour = 0;
        }
        return "${parsedHour.toString().padLeft(2, '0')}:${subParts[0].padLeft(2, '0')}";
      }

      final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
      return "$hour:$minute";
    }
    return "${time.padLeft(2, '0')}:00";
  }

  Future<void> submitService({required String serviceType}) async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        locationController.text.isEmpty) {
      CustomSnackBar.showError(message: 'Please fill all required fields');
      return;
    }

    if (serviceType == 'BOAT_RENTAL' && selectedBoatType.value.isEmpty) {
      CustomSnackBar.showError(message: 'Please select a boat type');
      return;
    }

    isLoading.value = true;

    Map<String, List<String>> multiFiles = {};
    if (servicePhotos.isNotEmpty) {
      multiFiles['photos'] = servicePhotos.map((e) => e.path).toList();
    }

    List<Map<String, dynamic>> includedServicesList = includedServices
        .map((e) => {"description": e})
        .toList();

    List<Map<String, dynamic>> additionalServicesList = additionalServices
        .map((e) => {
              "name": e['name'],
              "price": double.tryParse(e['price']!) ?? 0,
              "description": e['description'] ?? ""
            })
        .toList();

    Map<String, dynamic> requestBody = {
      "type": serviceType,
      "name": nameController.text,
      "description": descriptionController.text,
      "location": {
        "long": "90.4302855",
        "lat": "23.761041"
      },
      "timezone": "Asia/Dhaka",
      "address": locationController.text,
      "price": double.tryParse(priceController.text) ?? 0,
      "dailyStartTime": formatTime(startTimeController.text),
      "dailyEndTime": formatTime(endTimeController.text),
      if (includedServicesList.isNotEmpty) "includedServices": includedServicesList,
      if (additionalServicesList.isNotEmpty) "additionalServices": additionalServicesList,
      if (serviceType == 'BOAT_RENTAL') ...{
        "boatType": boatTypeApiMap[selectedBoatType.value] ?? selectedBoatType.value.toUpperCase().replaceAll(' ', '_'),
        if (modelController.text.isNotEmpty) "model": modelController.text,
        if (capacityController.text.isNotEmpty) "capacity": int.tryParse(capacityController.text) ?? 0,
        if (lengthController.text.isNotEmpty) "length": int.tryParse(lengthController.text) ?? 0,
      }
    };

    final isEdit = editId != null;
    final apiUrl = isEdit ? AppUrls.getServiceById(editId!) : AppUrls.getAllServices;
    final method = isEdit ? "PATCH" : "POST";

    final response = await _networkCaller.multiFormApiCall(
      apiUrl: apiUrl, 
      method: method,
      requestBody: requestBody,
      multiFiles: multiFiles.isNotEmpty ? multiFiles : null,
    );

    isLoading.value = false;

    if (response.isSuccess) {
      CustomSnackBar.showSuccess(message: isEdit ? 'Service updated successfully' : 'Service created successfully');
      if (Get.isRegistered<BusinessOwnerServiceController>()) {
        Get.find<BusinessOwnerServiceController>().fetchServices();
      }
      Get.back(); // Or navigate to another page
    } else {
      CustomSnackBar.showError(message: response.errorMessage);
    }
  }
}
