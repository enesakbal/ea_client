import 'fx_interface_network_model.dart';

abstract class FXInterfaceErrorModel<T extends FXInterfaceNetworkModel<T>?> {
  final String? description;
  final T? model;

  const FXInterfaceErrorModel({
    required this.description,
    required this.model,
  });
}
