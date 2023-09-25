// ignore_for_file: unused_field

import 'dart:developer';

import 'client_config.dart';
import 'core/enums/request_methods.dart';
import 'core/models/response_model.dart';
import 'interfaces/interface_client_model.dart';
import 'interfaces/interface_response_model.dart';

/// The NetworkManager class is an abstract class that defines a contract for managing network operations with models that
/// implement the NetworkManager interface.
abstract class EAClient {
  final ClientConfig _config;
  const EAClient({required ClientConfig config}) : _config = config;

  /// The `send` method is used to send an HTTP request to a specified `path` with various parameters. Here is a breakdown of
  /// the parameters:
  Future<InterfaceResponseModel<ResponseData?>>
      send<ParserModel extends InterfaceClientModel<ParserModel>, ResponseData>(
    String path, {
    required ParserModel parseModel,
    required RequestMethods method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  ResponseModel<Response> getResponseResult<ParserModel extends InterfaceClientModel<ParserModel>, Response>(
    dynamic data,
    ParserModel? parserModel,
    int? statusCode,
  ) {
    final model = parseBody<Response, ParserModel>(data, parserModel);

    return ResponseModel<Response>(
      data: model,
      statusCode: statusCode,
    );
  }

  Response? parseBody<Response, ParserModel extends InterfaceClientModel<ParserModel>>(
    dynamic responseBody,
    ParserModel? parserModel,
  ) {
    try {
      if (parserModel == null) {
        return null;
      } else {
        if (responseBody is List) {
          return responseBody
              .map(
                (data) => parserModel.fromJson(data is Map<String, dynamic> ? data : {}),
              )
              .cast<ParserModel>()
              .toList() as Response;
        } else if (responseBody is Map<String, dynamic>) {
          return parserModel.fromJson(responseBody) as Response;
        } else {
          log('Response body is not a List or a Map<String, dynamic>');
          return responseBody as Response;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
