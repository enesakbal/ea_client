import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../fx_network.dart';
import '../../../fx_network_config.dart';
import '../../../interfaces/fx_interface_network_model.dart';
import '../../../interfaces/fx_interface_response_model.dart';
import '../../enums/fx_request_methods.dart';
import '../../models/fx_empty_model.dart';
import '../../models/fx_error_model.dart';
import '../../models/fx_response_model.dart';

class DioClient<E extends FXInterfaceNetworkModel<E?>?> extends FXNetworkManager<E?> {
  final FXNetworkConfig _config;
  final dio.HttpClientAdapter _adapter;

  DioClient({required super.config, dio.HttpClientAdapter? adapter})
      : _config = config,
        _adapter = adapter ?? HttpClientAdapter();

  @override
  Future<FXInterfaceResponseModel<R?, E?>> send<T extends FXInterfaceNetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required FXRequestMethods method,
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

      if (data is FXInterfaceNetworkModel) {
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
        return getResponseResult<T, R>(response.data, parseModel, response.statusCode);
      }

      //* if has an error
      else {
        return ResponseModel<R, E?>(
          error: FXErrorModel(description: response.data.toString()),
          statusCode: response.statusCode,
        );
      }
    } on dio.DioException catch (e) {
      //* if has an error

      log(e.toString());
      return _onError<R>(e);
    }
  }

  ResponseModel<R, E?> _onError<R>(dio.DioException e) {
    final errorResponse = e.response;

    var error = FXErrorModel<E?>(description: e.message ?? e.response?.statusMessage ?? e.error.toString());

    if (errorResponse != null || _config.errorModel is EmptyModel) {
      error = generateFXErrorModel(error, errorResponse?.data);
    }
    return ResponseModel<R, E?>(
      error: FXErrorModel<E?>(
        description: error.description,
        model: error.model,
      ),
      statusCode: e.response?.statusCode,
    );
  }
}
