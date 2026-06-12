import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/views/screens/captain_booking_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/views/screens/business_owner_booking_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/views/screens/chat_screen.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/home/views/screens/captain_home_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/screens/user_home_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/views/user_explore_screen.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/icon_path.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/screens/profile_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/screens/business_owner_home_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/views/screens/business_owner_service_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/user_bookings._screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/create_account_dialogue.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class NavBarController extends GetxController {
  final _selectedIndex = 0.obs;
  late final String role;
  final showVerificationPending = false.obs;
  final isGuest = false.obs;

  int get currentIndex => _selectedIndex.value;

  /// Whether this role uses a floating action button in the center (user & businessowner)
  bool get hasFab => role == 'USER' || role == 'BUSINESS_OWNER';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    // Prefer the role passed as argument; fall back to StorageService (persisted role)
    role = (args?['role'] as String?)?.toUpperCase() ??
        StorageService.role?.toUpperCase() ??
        'USER';
    showVerificationPending.value = args?['showVerificationPending'] ?? false;
    isGuest.value = args?['isGuest'] ?? false;
  }

  void changeIndex(int index) {
    if (isGuest.value) {
      if (index == 0 || index == 1) {
        _selectedIndex.value = index;
      } else {
        _showGuestDialog();
      }
      return;
    }
    _selectedIndex.value = index;
  }

  void _showGuestDialog() {
    Get.dialog(const CreateAccountDialog());
  }

  /// Returns the list of screens based on the current role
  List<Widget> get screens {
    switch (role) {
      case 'USER':
        return [
          const UserHomeScreen(),
          const UserExploreScreen(),
          const UserBookingsScreen(), // FAB center item
          ChatScreen(),
          const ProfileScreen(),
        ];
      case 'BUSINESS_OWNER':
        return [
          const BusinessOwnerHomeScreen(),
          const BusinessOwnerServiceScreen(), // Service placeholder
          const BusinessOwnerBookingScreen(), // FAB center item
          ChatScreen(),
          const ProfileScreen(),
        ];
      case 'CAPTAIN':
      default:
        return [
          const CaptainHomeScreen(),
          const CaptainBookingScreen(),
          ChatScreen(),
          const ProfileScreen(),
        ];
    }
  }

  /// Returns nav item configs based on role
  List<NavItemData> get navItems {
    switch (role) {
      case 'USER':
        final ctx = Get.context!;
        return [
          NavItemData(icon: IconPath.home, label: AppLocalizations.of(ctx)!.navHome),
          NavItemData(icon: IconPath.explore, label: AppLocalizations.of(ctx)!.navExplore),
          NavItemData(icon: IconPath.booking, label: AppLocalizations.of(ctx)!.navBooking, isFab: true),
          NavItemData(icon: IconPath.chat, label: AppLocalizations.of(ctx)!.navChat),
          NavItemData(icon: IconPath.profile, label: AppLocalizations.of(ctx)!.navProfile),
        ];
      case 'BUSINESS_OWNER':
        final ctx2 = Get.context!;
        return [
          NavItemData(icon: IconPath.home, label: AppLocalizations.of(ctx2)!.navHome),
          NavItemData(icon: IconPath.booking, label: AppLocalizations.of(ctx2)!.navService),
          NavItemData(icon: IconPath.booking, label: AppLocalizations.of(ctx2)!.navBooking, isFab: true),
          NavItemData(icon: IconPath.chat, label: AppLocalizations.of(ctx2)!.navChat),
          NavItemData(icon: IconPath.profile, label: AppLocalizations.of(ctx2)!.navProfile),
        ];
      case 'CAPTAIN':
      default:
        final ctx3 = Get.context!;
        return [
          NavItemData(icon: IconPath.home, label: AppLocalizations.of(ctx3)!.navHome),
          NavItemData(icon: IconPath.booking, label: AppLocalizations.of(ctx3)!.navBooking),
          NavItemData(icon: IconPath.chat, label: AppLocalizations.of(ctx3)!.navChat),
          NavItemData(icon: IconPath.profile, label: AppLocalizations.of(ctx3)!.navProfile),
        ];
    }
  }
}

class NavItemData {
  final String icon;
  final String label;
  final bool isFab;

  const NavItemData({
    required this.icon,
    required this.label,
    this.isFab = false,
  });
}









