abstract class FXInterfaceNetworkModel<Model> {
  Map<String, dynamic>? toJson();
  Model fromJson(Map<String, dynamic> json);
}
