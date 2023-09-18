// ignore_for_file: overridden_fields

import '../../interfaces/fx_interface_error_model.dart';
import '../../interfaces/fx_interface_network_model.dart';

class ErrorModel<T extends FXInterfaceNetworkModel<T>?> extends FXInterfaceErrorModel<T> {
  ErrorModel({this.description, this.model});

  @override
  final String? description;

  @override
  final T? model;

  ErrorModel<T> copyWith({
    int? statusCode,
    String? description,
    T? model,
  }) {
    return ErrorModel<T>(
      description: description ?? this.description,
      model: model ?? this.model,
    );
  }
}
