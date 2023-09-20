import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'core/enums/fx_request_methods.dart';
import 'core/models/fx_empty_model.dart';
import 'core/models/fx_error_model.dart';
import 'core/models/fx_response_model.dart';
import 'fx_network_config.dart';
import 'interfaces/fx_interface_network_model.dart';
import 'interfaces/fx_interface_response_model.dart';

/// The FXNetworkManager class is an abstract class that defines a contract for managing network operations with models that
/// implement the FXNetworkManager interface.
abstract class FXNetworkManager<E extends FXInterfaceNetworkModel<E>?> {
  final FXNetworkConfig _config;
  const FXNetworkManager({required FXNetworkConfig config}) : _config = config;

  /// The `send` method is used to send an HTTP request to a specified `path` with various parameters. Here is a breakdown of
  /// the parameters:
  Future<FXInterfaceResponseModel<R?, E?>> send<T extends FXInterfaceNetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required FXRequestMethods method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  FXErrorModel<E?> generateFXErrorModel(FXErrorModel<E?> error, dynamic data) {
    var generatedError = error;
    if (_config.errorModel == null || _config.errorModel is EmptyModel) {
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

      generatedError = FXErrorModel<E?>(
        model: _config.errorModel?.fromJson(jsonBody) as E,
        description: error.description,
      );
    }

    if (data is Map<String, dynamic>) {
      final jsonBody = data;

      generatedError = FXErrorModel<E?>(
        model: _config.errorModel?.fromJson(jsonBody) as E,
        description: error.description,
      );
    }

    return generatedError;
  }

  ResponseModel<R, E?> getResponseResult<T extends FXInterfaceNetworkModel<T>, R>(
      dynamic data, T parserModel, int? statusCode) {
    final model = parseBody<R, T>(data, parserModel);

    return ResponseModel<R, E?>(
      data: model,
      error: model == null ? FXErrorModel(description: 'Null is returned after parsing a model $T') : null,
      statusCode: statusCode,
    );
  }

  R? parseBody<R, T extends FXInterfaceNetworkModel<T>>(dynamic responseBody, T model) {
    try {
      if (R is EmptyModel || R == EmptyModel) {
        return EmptyModel() as R;
      } else if (responseBody is List) {
        return responseBody
            .map(
              (data) => model.fromJson(data is Map<String, dynamic> ? data : {}),
            )
            .cast<T>()
            .toList() as R;
      } else if (responseBody is Map<String, dynamic>) {
        return model.fromJson(responseBody) as R;
      } else {
        log('Response body is not a List or a Map<String, dynamic>');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Map<String, dynamic>? setHeaders() {
    final Map<String, dynamic>? headers;
    if (_config.headers == null && _config.token != null) {
      headers = {HttpHeaders.authorizationHeader: 'Bearer ${_config.token}'};
    } else {
      _config.headers
          ?.addAll(_config.token != null ? {HttpHeaders.authorizationHeader: 'Bearer ${_config.token}'} : {});
      headers = _config.headers;
    }

    return headers;
  }
}
