abstract class BaseErrorModel<E> implements Exception {
  final String? description;
  final int? statusCode;
  final E? model;

  const BaseErrorModel({required this.description, this.model, this.statusCode});
}
