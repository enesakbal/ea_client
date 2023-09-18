import 'fx_interface_network_model.dart';

abstract class FXInterfaceErrorModel<T extends FXInterfaceNetworkModel<T>?> {
  String? description;
  T? model;
}
