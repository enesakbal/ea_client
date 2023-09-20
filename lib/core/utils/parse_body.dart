import 'dart:developer';

import '../../interfaces/fx_interface_network_model.dart';
import '../models/fx_empty_model.dart';

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
