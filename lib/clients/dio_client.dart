import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../client_config.dart';
import '../core/base/_export_base.dart';
import '../core/enums/request_types.dart';
import '../core/mixin/client_method_mixin.dart';
import '../core/models/error_model.dart';

class DioClient extends BaseEAClient with ClientMethodMixin {
  final ClientConfig _config;
  final dio.HttpClientAdapter _adapter;

  DioClient({required super.config, dio.HttpClientAdapter? adapter})
      : _config = config,
        _adapter = adapter ?? HttpClientAdapter();

  @override
  Future<BaseDataModel<R?>> send<P extends BaseSerializableModel<P>, R>(
    String path, {
    required RequestTypes method,
    P? parseModel,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //* set dio config
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: _config.baseUrl,
          method: method.stringValue,
          headers: _config.headers,
          queryParameters: queryParameters,
        ),
      )..httpClientAdapter = _adapter;

      //* if logging is true
      if (_config.logging) {
        dio.interceptors.add(
            PrettyDioLogger(compact: false, logPrint: (object) => log(object.toString(), name: '${_config.appName}')));
      }

      //* prepare body
      late final dynamic body;

      if (data is BaseSerializableModel) {
        body = data.toJson();
      } else if (data != null && data is! Map) {
        body = jsonEncode(data);
      } else {
        body = data;
      }

      //* send request
      final response = await dio.request(
        path,
        data: body,
      );
      final responseStatusCode = response.statusCode ?? HttpStatus.notFound;

      //* if success
      if (responseStatusCode >= HttpStatus.ok && responseStatusCode <= HttpStatus.multipleChoices) {
        return getResponseResult<P, R>(response.data, parseModel, response.statusCode);
      }
      throw _config.generateErrorModel(description: response.statusMessage ?? response.statusCode.toString());
    } on dio.DioException catch (e) {
      //* if has an error

      log(e.toString());
      throw _onError(e);
    }
  }

  ErrorModel<BaseSerializableModel<dynamic>> _onError(dio.DioException e) {
    final errorResponse = e.response;

    /// Creates a new ErrorModel object with the given description.
    final error = _config.generateErrorModel(description: e.message ?? e.response?.statusMessage ?? e.error.toString());

    /// Gets the data from the error response.
    final data = errorResponse?.data;

    /// If the data is a string, tries to decode it as JSON.
    if (data is String) {
      dynamic jsonBody;

      try {
        jsonBody = jsonDecode(data);

        /// If the decoded JSON is null or not a map, returns a new ErrorModel object with the given description and status code.
        if (jsonBody == null || jsonBody is! Map<String, dynamic>) {
          return _config.generateErrorModel(description: e.message, statusCode: e.response?.statusCode);
        }

        /// Otherwise, returns a new ErrorModel object with the given JSON body, description, and status code.
        return _config.generateErrorModel(
          jsonBody: jsonBody,
          description: e.message,
          statusCode: e.response?.statusCode,
        );
      } catch (e) {
        log(e.toString());
      }
    }

    /// If the data is a map, tries to cast it to a Map<String, dynamic>.
    if (data is Map<String, dynamic>) {
      /// Creates a new ErrorModel object with the given JSON body, description, and status code.
      final error = _config.generateErrorModel(
        jsonBody: data,
        description: e.message,
        statusCode: e.response?.statusCode,
      );

      /// Logs the error details.
      log(error.statusCode.toString());
      log(error.description.toString());
      log(error.model.toString());

      /// Returns the ErrorModel object.
      return error;
    }

    /// Otherwise, returns the original ErrorModel object.
    return error;
  }
}
