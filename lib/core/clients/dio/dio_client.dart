import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

import '../../../fx_network.dart';
import '../../../interfaces/fx_interface_network_model.dart';
import '../../../interfaces/fx_interface_response_model.dart';
import '../../enums/fx_request_methods.dart';
import '../../models/fx_empty_model.dart';
import '../../models/fx_error_model.dart';
import '../../models/fx_response_model.dart';

class DioClient<E extends FXInterfaceNetworkModel<E?>?> extends FXNetworkManager<E?> {
  DioClient({required super.config});

  @override
  Future<FXInterfaceResponseModel<R?, E?>> send<T extends FXInterfaceNetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required FXRequestMethods method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          method: method.stringValue,
          headers: config.headers,
        ),
      );
      final body = _getBodyModel(data);

      final response = await dio.request(
        path,
        data: body,
      );
      final responseStatusCode = response.statusCode ?? HttpStatus.notFound;

      if (responseStatusCode >= HttpStatus.ok && responseStatusCode <= HttpStatus.multipleChoices) {
        return _getResponseResult<T, R>(response.data, parseModel, response.statusCode);
      } else {
        return ResponseModel<R, E?>(
          error: ErrorModel(description: response.data.toString()),
          statusCode: response.statusCode,
        );
      }
    } on dio.DioException catch (e) {
      log(e.toString());
      return _onError<R>(e);
    }
  }

  ResponseModel<R, E?> _getResponseResult<T extends FXInterfaceNetworkModel<T>, R>(
      dynamic data, T parserModel, int? statusCode) {
    final model = _parseBody<R, T>(data, parserModel);

    return ResponseModel<R, E?>(
      data: model,
      error: model == null ? ErrorModel(description: 'Null is returned after parsing a model $T') : null,
      statusCode: statusCode,
    );
  }

  R? _parseBody<R, T extends FXInterfaceNetworkModel<T>>(dynamic responseBody, T model) {
    try {
      if (R is EmptyModel || R == EmptyModel) {
        return EmptyModel() as R;
      }

      if (responseBody is List) {
        return responseBody
            .map(
              (data) => model.fromJson(data is Map<String, dynamic> ? data : {}),
            )
            .cast<T>()
            .toList() as R;
      }

      if (responseBody is Map<String, dynamic>) {
        return model.fromJson(responseBody) as R;
      } else {
        /// Throwing exception if the response body is not a List or a Map<String, dynamic>.
        throw Exception(
          'Response body is not a List or a Map<String, dynamic>',
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  dynamic _getBodyModel(dynamic data) {
    if (data is FXInterfaceNetworkModel) {
      return data.toJson();
    } else if (data != null) {
      return jsonEncode(data);
    } else {
      return data;
    }
  }

  ResponseModel<R, E?> _onError<R>(dio.DioException e) {
    final errorResponse = e.response;

    var error = ErrorModel<E?>(description: e.message);

    if (errorResponse != null) {
      error = _generateErrorModel(error, errorResponse.data);
    }
    return ResponseModel<R, E?>(
      error: ErrorModel<E?>(
        description: error.description,
        model: error.model,
      ),
      statusCode: e.response?.statusCode,
    );
  }

  ErrorModel<E?> _generateErrorModel(ErrorModel<E?> error, dynamic data) {
    var generatedError = error;
    if (config.errorModel == null) {
      return generatedError;
    }

    if (data is String) {
      dynamic jsonBody;

      try {
        jsonBody = jsonDecode(data);
      } catch (_) {
        log('message');
      }

      if (jsonBody == null || jsonBody is! Map<String, dynamic>) return error;

      generatedError = error.copyWith(model: config.errorModel?.fromJson(jsonBody) as E);
    }

    if (data is Map<String, dynamic>) {
      final jsonBody = data;

      generatedError = error.copyWith(model: config.errorModel!.fromJson(jsonBody) as E);
    }

    return generatedError;
  }
}
