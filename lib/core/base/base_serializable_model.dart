/// The `BaseSerializableModel` class is an abstract class that provides methods for converting an
/// object to JSON and vice versa.
abstract class BaseSerializableModel<M> {
  Map<String, dynamic>? toJson();
  M fromJson(Map<String, dynamic> json);
}
