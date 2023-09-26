import '../error/network_exception.dart';

abstract class BaseErrorModel<E> implements Exception {
  final NetworkException? error;
  final E? model;

  const BaseErrorModel({required this.error, this.model});
}
