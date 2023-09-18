import '../../interfaces/fx_interface_network_model.dart';

class EmptyModel extends FXInterfaceNetworkModel<EmptyModel> {
  EmptyModel();

  EmptyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
  }

  @override
  Map<String, Object> toJson() {
    final data = <String, Object>{};
    return data;
  }

  @override
  EmptyModel fromJson(Map<String, dynamic>? json) {
    return EmptyModel.fromJson(json);
  }
}
