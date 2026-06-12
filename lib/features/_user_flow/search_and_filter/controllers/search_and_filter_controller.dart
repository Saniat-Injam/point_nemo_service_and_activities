import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAndFilterController {
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  Timer? _debounce;

  final void Function(String)? onSearch;

  SearchAndFilterController({this.onSearch});

  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchQuery.value != value.trim()) {
        searchQuery.value = value.trim();
        if (onSearch != null) {
          onSearch!(searchQuery.value);
        }
      }
    });
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
  }
}
