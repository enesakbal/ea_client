import '../base/base_serializable_model.dart';

class EmptyModel extends BaseSerializableModel<EmptyModel> {
  EmptyModel();

  @override
  Map<String, Object> toJson() => <String, Object>{};

  @override
  EmptyModel fromJson(Map<String, dynamic>? json) => this;
}
