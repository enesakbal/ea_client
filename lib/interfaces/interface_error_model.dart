import 'interface_client_model.dart';

abstract class InterfaceErrorModel<E> implements Exception {
  final String? description;
  final int? statusCode;
  final InterfaceClientModel<E>? model;

  const InterfaceErrorModel({required this.description, this.model, this.statusCode});
}
