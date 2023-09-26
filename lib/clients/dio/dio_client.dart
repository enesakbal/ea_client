// Import necessary libraries and dependencies
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../client_config.dart';
import '../../core/base/_export_base.dart';
import '../../core/enums/request_types.dart';
import '../../core/error/network_exception.dart';
import '../../core/mixin/client_method_mixin.dart';
import '../../core/models/error_model.dart';

// Define the DioClient class which extends BaseEAClient and uses ClientMethodMixin
class DioClient extends BaseEAClient with ClientMethodMixin {
  final ClientConfig _config; // Configuration for the client
  final dio.HttpClientAdapter _adapter; // HTTP client adapter for Dio

  // Constructor for DioClient
  DioClient({required super.config, dio.HttpClientAdapter? adapter})
      : _config = config,
        _adapter = adapter ?? HttpClientAdapter();

  // Method for sending HTTP requests
  @override
  Future<BaseDataModel<R?>> send<P extends BaseSerializableModel<P>, R>(
    String path, {
    required RequestTypes method,
    P? parserModel,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Create a Dio instance with the provided configuration
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: _config.baseUrl,
          method: method.stringValue,
          headers: _config.headers,
          queryParameters: queryParameters,
        ),
      )..httpClientAdapter = _adapter;

      // Add logging interceptor if configured
      if (_config.logging) {
        dio.interceptors.add(
          PrettyDioLogger(compact: false, logPrint: (object) => log(object.toString(), name: '${_config.appName}')),
        );
      }

      late final dynamic body;

      // Serialize the request data based on its type
      if (data is BaseSerializableModel) {
        body = data.toJson();
      } else if (data != null && data is! Map) {
        body = jsonEncode(data);
      } else {
        body = data;
      }

      // Send the HTTP request using Dio
      final response = await dio.request(
        path,
        data: body,
      );
      final responseStatusCode = response.statusCode ?? HttpStatus.notFound;

      // Check if the response status code is within the success range
      if (responseStatusCode >= HttpStatus.ok && responseStatusCode <= HttpStatus.multipleChoices) {
        return getResponseResult<P, R>(data: response.data, parserModel: parserModel, statusCode: responseStatusCode);
      }
      throw _config.generateErrorModel(error: NetworkException.fromDioError(DioExceptionType.unknown));
    } on dio.DioException catch (e) {
      log(e.toString());
      throw _onError(e);
    }
  }

  // Handle errors and generate error models
  // Handle Dio errors and generate error models
  ErrorModel<BaseSerializableModel<dynamic>> _onError(dio.DioException e) {
    final errorResponse = e.response;
    final data = errorResponse?.data;

    // Check if the error response data is a string
    if (data is String) {
      dynamic jsonBody;

      try {
        // Attempt to parse the error response data as JSON
        jsonBody = jsonDecode(data);

        // If parsing is successful and the JSON body is a map
        if (jsonBody == null || jsonBody is! Map<String, dynamic>) {
          // Generate an error model for a network exception
          return _config.generateErrorModel(
            error: NetworkException.fromDioError(e.type, statusCode: e.response?.statusCode),
          );
        }

        // Generate an error model with the JSON body and exception details
        return _config.generateErrorModel(
          jsonBody: jsonBody,
          error: NetworkException.fromDioError(e.type, statusCode: e.response?.statusCode),
        );
      } catch (e) {
        // Log any errors that occur during JSON parsing
        log(e.toString());
      }
    }

    // Check if the error response data is a map
    if (data is Map<String, dynamic>) {
      // Generate an error model with the map data and exception details
      final error = _config.generateErrorModel(
        jsonBody: data,
        error: NetworkException.fromDioError(e.type, statusCode: e.response?.statusCode),
      );

      // Log the error message and model details
      log(error.error?.message ?? '');
      log(error.model.toString());

      return error;
    }

    // If the error response data is not a string or map, generate a generic error model
    return _config.generateErrorModel(error: NetworkException.fromDioError(e.type, statusCode: e.response?.statusCode));
  }
}
