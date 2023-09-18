import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../fx_network.dart';
import '../../../interfaces/fx_interface_network_model.dart';
import '../../../interfaces/fx_interface_response_model.dart';
import '../../enums/fx_request_methods.dart';
import '../../models/fx_empty_model.dart';
import '../../models/fx_error_model.dart';
import '../../models/fx_response_model.dart';

class HttpClient<E extends FXInterfaceNetworkModel<E>?>
    extends FXNetworkManager<E> {
  HttpClient({required super.config});
  @override
  Future<FXInterfaceResponseModel<R?, E?>>
      send<T extends FXInterfaceNetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required FXRequestMethods method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final client = http.Client();
      final baseRequest =
          http.Request(method.stringValue, Uri.parse(config.baseUrl + path))
            ..body = data.toString();

      final response = await client.send(baseRequest);

      final responseBytes = await response.stream.toBytes();
      final responseBody = jsonDecode(String.fromCharCodes(responseBytes));

      client.close();
      print(response.statusCode);

      return _getResponseResult<T, R>(responseBody, parseModel);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  ResponseModel<R, E>
      _getResponseResult<T extends FXInterfaceNetworkModel<T>, R>(
    dynamic data,
    T parserModel,
  ) {
    final model = _parseBody<R, T>(data, parserModel);

    return ResponseModel<R, E>(
      data: model,
      error: model == null
          ? ErrorModel(description: 'Null is returned after parsing a model $T')
          : null,
    );
  }

  R? _parseBody<R, T extends FXInterfaceNetworkModel<T>>(
      dynamic responseBody, T model) {
    try {
      if (R is EmptyModel || R == EmptyModel) {
        return EmptyModel() as R;
      }

      if (responseBody is List) {
        return responseBody
            .map(
              (data) =>
                  model.fromJson(data is Map<String, dynamic> ? data : {}),
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
}
