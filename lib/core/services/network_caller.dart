import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:point_nemo_service_and_activities/core/models/response_data.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/logger.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';

class NetworkCaller {
  final int timeoutDuration = 10;

  Future<ResponseData> getRequest(String endpoint, {String? token}) async {
    AppLoggerHelper.info('GET Request: $endpoint');
    try {
      final Response response = await get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? 'Bearer ${StorageService.token ?? ''}',
          'Content-type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('POST Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? 'Bearer ${StorageService.token ?? ''}',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multiFormApiCall({
    required String apiUrl,
    Map<String, dynamic>? requestBody,
    Map<String, String>? singleFiles,
    Map<String, List<String>>? multiFiles,
    required String method,
    int timeoutDuration = 40,
  }) async {
    try {
      var request = http.MultipartRequest(
        method.toUpperCase(),
        Uri.parse(apiUrl),
      );

      /// Assign Body
      if (requestBody != null) {
        request.fields['data'] = jsonEncode(requestBody);
        AppLoggerHelper.info("body for server is: ${requestBody.toString()}");
      }

      request.headers['Authorization'] = 'Bearer ${StorageService.token}';
      request.headers['Accept'] = 'application/json';

      /// Submitting single files
      if (singleFiles != null) {
        for (var entry in singleFiles.entries) {
          if (entry.value.isNotEmpty) {
            final mimeType = lookupMimeType(entry.value) ?? "image/jpeg";
            final splitMime = mimeType.split('/');

            request.files.add(
              await http.MultipartFile.fromPath(
                entry.key,
                entry.value,
                contentType: MediaType(
                  splitMime[0],
                  splitMime.length > 1 ? splitMime[1] : '',
                ),
              ),
            );
          }
        }
      }

      /// Submitting multiple files
      if (multiFiles != null) {
        for (var entry in multiFiles.entries) {
          for (var path in entry.value) {
            if (path.isNotEmpty) {
              final mimeType = lookupMimeType(path) ?? "image/jpeg";
              final splitMime = mimeType.split('/');

              request.files.add(
                await http.MultipartFile.fromPath(
                  entry.key,
                  path,
                  contentType: MediaType(
                    splitMime[0],
                    splitMime.length > 1 ? splitMime[1] : '',
                  ),
                ),
              );
            }
          }
        }
      }

      /// sending request with timeout
      final response = await request.send().timeout(
        Duration(seconds: timeoutDuration),
      );

      var streamedResponse = await http.Response.fromStream(response);
      return _handleResponse(streamedResponse);
    } on TimeoutException {
      return _handleError("Request timeout after $timeoutDuration seconds");
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PUT Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? 'Bearer ${StorageService.token ?? ''}',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PATCH Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await patch(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? 'Bearer ${StorageService.token ?? ''}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(String endpoint, String? token) async {
    AppLoggerHelper.info('DELETE Request: $endpoint');
    try {
      final Response response = await delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? 'Bearer ${StorageService.token ?? ''}',
          'Content-type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle the response from the server
  Future<ResponseData> _handleResponse(http.Response response) async {
    AppLoggerHelper.info('Response Status: ${response.statusCode}');
    AppLoggerHelper.info('Response Body: ${response.body}');

    try {
      final decodedResponse = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
        case 201:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage: '',
          );
        case 204:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage: '',
          );
        case 400:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage:
                decodedResponse['error'] ??
                'There was an issue with your request. Please try again.',
            responseData: decodedResponse,
          );
        case 401:
          // Try to refresh the token before forcing a logout
          log('401 received — attempting token refresh...');
          final refreshed = await StorageService.refreshAccessToken();
          if (!refreshed) {
            log('Token refresh failed — logging out');
            await StorageService.logoutUser();
          }
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'You are not authorized. Please log in to continue.',
            responseData: decodedResponse,
          );
        case 403:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'You do not have permission to access this resource.',
            responseData: decodedResponse,
          );
        case 404:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'The resource you are looking for was not found.',
            responseData: decodedResponse,
          );
        case 500:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'Internal server error. Please try again later.',
            responseData: decodedResponse,
          );
        default:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage:
                decodedResponse['error'] ??
                'Something went wrong. Please try again.',
            responseData: decodedResponse,
          );
      }
    } catch (e) {
      // Response body is not valid JSON (e.g. HTML error page)
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Failed to process the response. Please try again later.',
        responseData: response.body,
      );
    }
  }

  // Handle errors during the request process
  ResponseData _handleError(dynamic error) {
    log('Request Error: $error');

    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage:
            'Request timed out. Please check your internet connection and try again.',
        responseData: null,
      );
    } else if (error is http.ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage:
            'Network error occurred. Please check your connection and try again.',
        responseData: null,
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Unexpected error occurred. Please try again later.',
        responseData: null,
      );
    }
  }
}
