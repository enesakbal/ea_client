abstract class InterfaceErrorModel<E> implements Exception {
  final String? description;
  final int? statusCode;
  final E? model;

  const InterfaceErrorModel({required this.description, this.model, this.statusCode});
}
