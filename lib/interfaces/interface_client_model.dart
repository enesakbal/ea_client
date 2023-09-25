abstract class InterfaceClientModel<M> {
  Map<String, dynamic>? toJson();
  M fromJson(Map<String, dynamic> json);
}
