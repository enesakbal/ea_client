import '../error/network_exception.dart';

/// The `BaseErrorModel` class is an abstract class that represents an error with an optional associated
/// model.
abstract class BaseErrorModel<E> implements Exception {
  final NetworkException? error;
  final E? model;

  const BaseErrorModel({required this.error, this.model});
}
