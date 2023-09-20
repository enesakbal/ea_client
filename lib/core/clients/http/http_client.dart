import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../fx_network.dart';
import '../../../fx_network_config.dart';
import '../../../interfaces/fx_interface_network_model.dart';
import '../../../interfaces/fx_interface_response_model.dart';
import '../../enums/fx_request_methods.dart';
import '../../models/fx_empty_model.dart';
import '../../models/fx_error_model.dart';
import '../../models/fx_response_model.dart';

class HttpClient<Error extends FXInterfaceNetworkModel<Error>?> extends FXNetworkManager<Error> {
  final FXNetworkConfig _config;
  final bool isTesting;
  final MockClient? mockClient;
  HttpClient({required super.config, this.isTesting = false, this.mockClient}) : _config = config;

  @override
  Future<FXInterfaceResponseModel<Response?, Error?>>
      send<ParserModel extends FXInterfaceNetworkModel<ParserModel>, Response>(
    String path, {
    required ParserModel parseModel,
    required FXRequestMethods method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (isTesting && mockClient == null) throw Exception('In the testing mode mockClient cant be null');

    try {
      //* Set URI
      final uri = Uri.parse(_config.baseUrl + path)
        ..replace(
          queryParameters: queryParameters?..updateAll((key, value) => value.toString()),
        );

      //* Client Desicion
      late final http.Client client;

      if (isTesting && mockClient != null) {
        client = mockClient!;
      } else {
        client = http.Client();
      }

      //* set Request options

      late final dynamic body;

      if (data is FXInterfaceNetworkModel) {
        body = data.toJson();
      } else if (data != null) {
        body = jsonEncode(data);
      } else {
        body = data;
      }

      final baseRequest = http.Request(method.stringValue, uri)
        ..body = (data == 'null' || data == null) ? '' : body.toString()
        ..headers.clear()
        ..headers.addAll(setHeaders()?.cast<String, String>() ?? {});

      //* SEND REQUEST
      final response = await client.send(baseRequest);

      //* when success
      final responseBytes = await response.stream.toBytes();
      final responseBody = jsonDecode(String.fromCharCodes(responseBytes));

      //* when has an error
      if (response.statusCode > HttpStatus.multipleChoices) {
        return _onError(responseBody, response.statusCode);
      }
      client.close();

      //* return response
      return getResponseResult<ParserModel, Response>(responseBody, parseModel, response.statusCode);
    } on SocketException {
      return ResponseModel<Response, Error?>(
        error: FXErrorModel(description: 'No internet.'),
      );
    } on HttpException catch (e) {
      return ResponseModel<Response, Error?>(
        error: FXErrorModel(description: e.message),
      );
    } on http.ClientException catch (e) {
      return ResponseModel<Response, Error?>(
        error: FXErrorModel(description: e.message),
      );
    }
  }

  ResponseModel<Response, Error?> _onError<Response>(dynamic responseData, int statusCode) {
    var error = FXErrorModel<Error?>(description: responseData.toString());

    if (responseData != null || _config.errorModel is EmptyModel) {
      error = generateFXErrorModel(error, responseData);
    }
    return ResponseModel<Response, Error?>(
      error: FXErrorModel<Error?>(
        description: error.description,
        model: error.model,
      ),
      statusCode: statusCode,
    );
  }
}
