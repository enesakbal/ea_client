import 'dart:developer';

import '../base/_export_base.dart';
import '../models/_export_models.dart';

mixin ClientMethodMixin {
  /// The function `getResponseResult` takes in data, a parser model, and a status code, and returns a
  /// response model with the parsed data and status code.
  ///
  /// Args:
  ///   data (dynamic): The `data` parameter is the response data that needs to be parsed and converted
  /// into the desired model object. It can be of any type, such as a JSON string or a raw response
  /// object.
  ///   parserModel (P): The `parserModel` parameter is an optional instance of a class that extends
  /// `BaseSerializableModel`. It is used to parse the `data` parameter into an instance of the specified
  /// model class.
  ///   statusCode (int): The `statusCode` parameter represents the HTTP status code of the response. It
  /// is an integer value that indicates the success or failure of the request.
  ///
  /// Returns:
  ///   an instance of `ResponseModel<R>`.
  ResponseModel<R> getResponseResult<P extends BaseSerializableModel<P>, R>({
    required dynamic data,
    required P? parserModel,
    required int statusCode,
  }) {
    final model = parseBody<R, P>(data, parserModel);

    return ResponseModel<R>(
      data: model,
      statusCode: statusCode,
    );
  }

  /// The function `parseBody` is used to parse a response body into a specified type, using a parser
  /// model.
  ///
  /// Args:
  ///   responseBody (dynamic): The `responseBody` parameter is the dynamic data that is received as a
  /// response from an API call. It can be either a List or a Map<String, dynamic> depending on the
  /// structure of the response.
  ///   parserModel (P): The `parserModel` parameter is an instance of a class that extends
  /// `BaseSerializableModel`. It is used to parse the `responseBody` into an object of type `P`. The
  /// `fromJson` method of the `parserModel` is called to deserialize the `responseBody` into an object
  ///
  /// Returns:
  ///   The method is returning an object of type R.
  R? parseBody<R, P extends BaseSerializableModel<P>>(
    dynamic responseBody,
    P? parserModel,
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
              .cast<P>()
              .toList() as R;
        } else if (responseBody is Map<String, dynamic>) {
          return parserModel.fromJson(responseBody) as R;
        } else {
          log('Response body is not a List or a Map<String, dynamic>');
          return responseBody as R;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
