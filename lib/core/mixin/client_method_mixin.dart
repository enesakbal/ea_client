import 'dart:developer';

import '../base/_export_base.dart';
import '../models/_export_models.dart';

mixin ClientMethodMixin {
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
