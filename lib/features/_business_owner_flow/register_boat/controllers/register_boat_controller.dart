import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/register_boat/models/boat_type_model.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_snackbar.dart';

class RegisterBoatController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final lengthController = TextEditingController();
  final priceController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final includedServiceController = TextEditingController();
  final RxList<String> includedServices = <String>[].obs;
  final descriptionController = TextEditingController();

  final additionalServiceNameController = TextEditingController();
  final additionalServicePriceController = TextEditingController();

  final selectedBoatType = ''.obs;
  final boatTypeError = ''.obs;

  final isLoading = false.obs;

  final Rx<File?> boatCoverImage = Rx<File?>(null);
  final RxList<File> boatPhotos = <File>[].obs;
  final Rx<File?> nidImage = Rx<File?>(null);
  final Rx<File?> docsFile = Rx<File?>(null);

  final NetworkCaller _networkCaller = NetworkCaller();

  final RxList<Map<String, String>> additionalServices = <Map<String, String>>[].obs;

  final List<BoatTypeModel> boatTypes = [
    BoatTypeModel(name: 'Motorboat', imagePath: ImagePath.motorboat),
    BoatTypeModel(name: 'Catamaran', imagePath: ImagePath.catamaran),
    BoatTypeModel(name: 'Rib', imagePath: ImagePath.rib),
    BoatTypeModel(name: 'Jet ski', imagePath: ImagePath.jetSki),
    BoatTypeModel(name: 'Gulet', imagePath: ImagePath.gulet),
    BoatTypeModel(name: 'Houseboat', imagePath: ImagePath.houseboat),
  ];


  void selectBoatType(String name) {
    selectedBoatType.value = name;
    boatTypeError.value = '';
  }

  void addIncludedService() {
    final text = includedServiceController.text.trim();
    if (text.isNotEmpty) {
      if (includedServices.length < 8) {
        if (!includedServices.contains(text)) {
          includedServices.add(text);
          includedServiceController.clear();
        } else {
          CustomSnackBar.showError(message: 'This service is already added');
        }
      } else {
        CustomSnackBar.showError(message: 'You can only add up to 8 included services');
      }
    } else {
      CustomSnackBar.showError(message: 'Please enter a service name');
    }
  }

  void removeIncludedService(String service) {
    includedServices.remove(service);
  }

  void addAdditionalService() {
    if (additionalServiceNameController.text.isNotEmpty && additionalServicePriceController.text.isNotEmpty) {
      additionalServices.add({
        "name": additionalServiceNameController.text,
        "price": additionalServicePriceController.text,
      });
      additionalServiceNameController.clear();
      additionalServicePriceController.clear();
    } else {
      CustomSnackBar.showError(message: 'Please fill all fields');
    }
  }

  void removeAdditionalService(Map<String, String> service) {
    additionalServices.remove(service);
  }

  Future<void> takeBoatPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (boatCoverImage.value == null) {
        boatCoverImage.value = File(image.path);
      } else if (boatPhotos.length < 2) {
        boatPhotos.add(File(image.path));
      } else {
        CustomSnackBar.showError(message: 'You can only upload up to 3 photos');
      }
    }
  }

  Future<void> pickBoatImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var img in images) {
        if (boatCoverImage.value == null) {
          boatCoverImage.value = File(img.path);
        } else if (boatPhotos.length < 2) {
          boatPhotos.add(File(img.path));
        }
      }
    }
  }

  Future<void> pickAdditionalPhotos() async {
    // Kept for compatibility if used elsewhere, though not wired to UI thumbnails anymore
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var img in images) {
        if (boatPhotos.length < 2) {
          boatPhotos.add(File(img.path));
        }
      }
    }
  }

  void removeBoatPhoto(int index) {
    if (index == 0) {
      if (boatPhotos.isNotEmpty) {
        boatCoverImage.value = boatPhotos.first;
        boatPhotos.removeAt(0);
      } else {
        boatCoverImage.value = null;
      }
    } else if (index == 1) {
      if (boatPhotos.isNotEmpty) {
        boatPhotos.removeAt(0);
      }
    } else if (index == 2) {
      if (boatPhotos.length > 1) {
        boatPhotos.removeAt(1);
      }
    }
  }

  Future<void> takeNidPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      nidImage.value = File(image.path);
    }
  }

  Future<void> pickNidImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      nidImage.value = File(image.path);
    }
  }

  Future<void> takeDocsPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      docsFile.value = File(image.path);
    }
  }

  Future<void> pickDocsImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      docsFile.value = File(result.files.single.path!);
    }
  }

  Future<void> saveBoat() async {
    bool isFormValid = formKey.currentState!.validate();
    bool isBoatTypeValid = selectedBoatType.value.isNotEmpty;

    if (!isBoatTypeValid) {
      boatTypeError.value = 'Boat type is required';
    }

    if (!isFormValid || !isBoatTypeValid) {
      if (isFormValid && !isBoatTypeValid) {
        CustomSnackBar.showError(message: 'Please select a boat type');
      } else {
        CustomSnackBar.showError(message: 'Please fill all the required fields');
      }
      return;
    }

    isLoading.value = true;

    Map<String, String> singleFiles = {};
    if (boatCoverImage.value != null) {
      singleFiles['coverImage'] = boatCoverImage.value!.path;
    }
    if (nidImage.value != null) {
      singleFiles['ownerNidUrl'] = nidImage.value!.path;
    }

    Map<String, List<String>> multiFiles = {};
    if (boatPhotos.isNotEmpty) {
      multiFiles['photos'] = boatPhotos.map((e) => e.path).toList();
    }
    if (docsFile.value != null) {
      multiFiles['documents'] = [docsFile.value!.path];
    }

    String formatTime(String time) {
      if (time.isEmpty) return "09:00";
      if (time.contains(':')) {
        final parts = time.split(':');
        final hour = parts[0].padLeft(2, '0');
        final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
        return "$hour:$minute";
      }
      return "${time.padLeft(2, '0')}:00";
    }

    final String selectedBoatEnum = selectedBoatType.value.toUpperCase().replaceAll(' ', '_');

    Map<String, dynamic> requestBody = {
      "type": "BOAT_RENTAL",
      "boatType": selectedBoatEnum,
      "name": nameController.text,
      "description": descriptionController.text,
      "location": {
        "long": "0.00",
        "lat": "0.00"
      },
      "address": locationController.text,
      "price": double.tryParse(priceController.text) ?? 0,
      "timezone": "Asia/Dhaka",
      "dailyStartTime": formatTime(startTimeController.text),
      "dailyEndTime": formatTime(endTimeController.text),
      "boatRentalDetails": {
        "boatType": selectedBoatEnum,
        "model": modelController.text,
        "capacity": int.tryParse(capacityController.text) ?? 0,
        "length": int.tryParse(lengthController.text) ?? 0,
      },
      "includedServices": [
        ...includedServices.map((e) => {"description": e}),
        if (includedServiceController.text.trim().isNotEmpty && !includedServices.contains(includedServiceController.text.trim()))
          {"description": includedServiceController.text.trim()}
      ],
      if (additionalServices.isNotEmpty)
        "additionalServices": additionalServices.map((e) => {
          "name": e['name'],
          "price": double.tryParse(e['price']!) ?? 0,
        }).toList(),
    };

    final response = await _networkCaller.multiFormApiCall(
      apiUrl: AppUrls.getAllServices, // Maps to base_url/service which is exactly what we need
      method: "POST",
      requestBody: requestBody,
      singleFiles: singleFiles.isNotEmpty ? singleFiles : null,
      multiFiles: multiFiles.isNotEmpty ? multiFiles : null,
    );

    isLoading.value = false;

    if (response.isSuccess) {
      CustomSnackBar.showSuccess(message: 'Registration submitted successfully!');
      Get.offAllNamed(
        AppRoute.mainBottomNavBar,
        arguments: {
          'role': 'BUSINESS_OWNER',
          'isGuest': false,
          'showVerificationPending': true,
        },
      );
    } else {
      CustomSnackBar.showError(message: response.errorMessage);
    }
  }

  @override
  void onClose() {
    locationController.dispose();
    nameController.dispose();
    modelController.dispose();
    capacityController.dispose();
    lengthController.dispose();
    priceController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    includedServiceController.dispose();
    descriptionController.dispose();
    additionalServiceNameController.dispose();
    additionalServicePriceController.dispose();
    super.onClose();
  }
}
