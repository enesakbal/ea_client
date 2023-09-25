import '../base/base_error_model.dart';

class ErrorModel<E> extends BaseErrorModel<E> {
  ErrorModel({required super.description, super.model, super.statusCode});
}
