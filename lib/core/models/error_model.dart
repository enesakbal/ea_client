import '../base/base_error_model.dart';
import '../base/base_serializable_model.dart';

/// The class ErrorModel is a generic class that extends BaseErrorModel and takes a type parameter E
/// which must extend BaseSerializableModel, and it has two optional named parameters error and model.
class ErrorModel<E extends BaseSerializableModel<dynamic>> extends BaseErrorModel<E> {
  ErrorModel({required super.error, super.model});
}
