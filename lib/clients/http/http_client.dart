import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../client_config.dart';
import '../../core/base/_export_base.dart';
import '../../core/enums/request_types.dart';
import '../../core/enums/server_client_exceptions.dart';
import '../../core/error/network_exception.dart';
import '../../core/mixin/client_method_mixin.dart';
import '../../core/models/error_model.dart';

class HttpClient extends BaseEAClient with ClientMethodMixin {
  final ClientConfig _config;
  final BaseClient? baseClient;

  HttpClient({required super.config, this.baseClient}) : _config = config;

  @override
  Future<BaseDataModel<R?>> send<P extends BaseSerializableModel<P>, R>(
    String path, {
    required P parserModel,
    required RequestTypes method,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //* Set URI
      final uri = Uri.parse(_config.baseUrl + path)
        ..replace(
          queryParameters: queryParameters?..updateAll((key, value) => value.toString()),
        );

      //* Client Desicion
      late final http.Client client;

      if (baseClient != null) {
        client = baseClient!;
      } else {
        client = http.Client();
      }

      //* set Request options

      late final dynamic body;

      if (data is BaseSerializableModel) {
        body = data.toJson();
      } else if (data != null) {
        body = jsonEncode(data);
      } else {
        body = data;
      }

      final baseRequest = http.Request(method.stringValue, uri)
        ..body = (data == 'null' || data == null) ? '' : body.toString()
        ..headers.clear()
        ..headers.addAll(_config.headers?.cast<String, String>() ?? {});

      //* SEND REQUEST
      final response = await client.send(baseRequest);

      //* when has an error
      if (response.statusCode > HttpStatus.multipleChoices) {
        final exception = await _onError(response);
        throw exception;
      } else {
        final responseBytes = await response.stream.toBytes();
        final data = jsonDecode(String.fromCharCodes(responseBytes));

        client.close();
        return getResponseResult<P, R>(data: data, parserModel: parserModel, statusCode: response.statusCode);
      }

      //* return response
    } on ErrorModel {
      rethrow;
    } on Exception catch (e) {
      log(e.toString());

      throw _config.generateErrorModel(
        error: NetworkException(
          exceptionType: ServerExceptionType.unexpectedError,
          message: e.toString(),
          statusCode: -1,
        ),
      );
    }
  }

  Future<ErrorModel<BaseSerializableModel<dynamic>>> _onError<Response>(StreamedResponse response) async {
    final responseBytes = await response.stream.toBytes();
    final data = jsonDecode(String.fromCharCodes(responseBytes));

    if (data != null) {
      if (data is String) {
        dynamic jsonBody;

        try {
          jsonBody = jsonDecode(data);

          late final ErrorModel<BaseSerializableModel<dynamic>> exception;

          /// If the decoded JSON is null or not a map, returns a new ErrorModel object with the given description and status code.
          if (jsonBody == null || jsonBody is! Map<String, dynamic>) {
            exception = _config.generateErrorModel(error: NetworkException.fromHttpError(response));
          } else {
            exception = _config.generateErrorModel(jsonBody: jsonBody, error: NetworkException.fromHttpError(response));
          }

          /// Otherwise, returns a new ErrorModel object with the given JSON body, description, and status code.
          return exception;
        } catch (e) {
          log(e.toString());
        }
      }

      /// If the data is a map, tries to cast it to a Map<String, dynamic>.
      if (data is Map<String, dynamic>) {
        /// Creates a new ErrorModel object with the given JSON body, description, and status code.
        final exception = _config.generateErrorModel(jsonBody: data, error: NetworkException.fromHttpError(response));

        /// Logs the error details.
        log(exception.error?.message ?? 'error message is null');
        log(exception.error?.statusCode.toString() ?? 'status code is null');
        log(exception.model.toString());

        /// Returns the ErrorModel object.
        return exception;
      }
    }

    return _config.generateErrorModel(error: NetworkException.fromHttpError(response));
  }
}
