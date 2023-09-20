import 'fx_interface_network_model.dart';

abstract class FXInterfaceErrorModel<Error extends FXInterfaceNetworkModel<Error>?> {
  final String? description;
  final Error? model;

  const FXInterfaceErrorModel({
    required this.description,
    required this.model,
  });
}
