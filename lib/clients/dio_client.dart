// ignore_for_file: strict_raw_type

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../client_config.dart';
import '../core/enums/request_methods.dart';
import '../core/models/error_model.dart';
import '../ea_client.dart';
import '../interfaces/interface_client_model.dart';
import '../interfaces/interface_response_model.dart';

class DioClient extends EAClient {
  final ClientConfig _config;
  final dio.HttpClientAdapter _adapter;

  DioClient({required super.config, dio.HttpClientAdapter? adapter})
      : _config = config,
        _adapter = adapter ?? HttpClientAdapter();

  @override
  Future<InterfaceResponseModel<ResponseData?>>
      send<ParserModel extends InterfaceClientModel<ParserModel>, ResponseData>(
    String path, {
    required RequestMethods method,
    ParserModel? parseModel,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //* set dio config
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: _config.baseUrl,
          method: method.stringValue,
          headers: setHeaders(),
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

      if (data is InterfaceClientModel) {
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
        return getResponseResult<ParserModel, ResponseData>(response.data, parseModel, response.statusCode);
      }

      throw ErrorModel(description: response.statusMessage ?? response.statusCode.toString());
    } on dio.DioException catch (e) {
      //* if has an error

      log(e.toString());
      throw _onError(e);
    }
  }

  ErrorModel _onError(dio.DioException e) {
    final errorResponse = e.response;

    var error = ErrorModel(description: e.message ?? e.response?.statusMessage ?? e.error.toString());

    if (errorResponse != null) {
      error = generateErrorModel(errorResponse.data, e);
    }
    return ErrorModel(description: error.description, model: error.model, statusCode: e.response?.statusCode);
  }

  ErrorModel generateErrorModel(dynamic data, dio.DioException e) {
    //  var generatedError = error;
    if (data is String) {
      dynamic jsonBody;

      try {
        jsonBody = jsonDecode(data);
        if (jsonBody == null || jsonBody is! Map<String, dynamic>) {
          return ErrorModel(description: e.message, statusCode: e.response?.statusCode);
        }

        return ErrorModel(
          model: _config.errorModel.fromJson(jsonBody) as InterfaceClientModel,
          description: e.message,
          statusCode: e.response?.statusCode,
        );
      } catch (e) {
        log(e.toString());
      }
    }

    try {
      if (data is Map<String, dynamic>) {
        final jsonBody = data;

        return ErrorModel(
          model: _config.errorModel.fromJson(jsonBody) as InterfaceClientModel,
          description: e.message,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return ErrorModel(description: e.message, statusCode: e.response?.statusCode);
  }
}
