abstract class BaseSerializableModel<M> {
  Map<String, dynamic>? toJson();
  M fromJson(Map<String, dynamic> json);
}
