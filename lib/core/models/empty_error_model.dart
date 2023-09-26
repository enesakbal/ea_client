import '../base/base_serializable_model.dart';

class EmptyErrorModel<E> extends BaseSerializableModel<EmptyErrorModel<dynamic>> {
  /// The class ErrorModel is a generic class that extends BaseErrorModel and takes a type parameter E
  /// which must extend BaseSerializableModel, and it has two optional named parameters error and model.
  EmptyErrorModel();

  @override
  Map<String, Object> toJson() => <String, Object>{};

  @override
  EmptyErrorModel<E> fromJson(Map<String, dynamic>? json) => this;
}
