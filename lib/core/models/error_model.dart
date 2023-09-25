import '../../interfaces/interface_error_model.dart';

class ErrorModel<E> extends InterfaceErrorModel<E> {
  ErrorModel({required super.description, super.model,super.statusCode});
}
