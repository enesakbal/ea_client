import '../../interfaces/fx_interface_error_model.dart';
import '../../interfaces/fx_interface_network_model.dart';

class FXErrorModel<T extends FXInterfaceNetworkModel<T>?> extends FXInterfaceErrorModel<T> {
  FXErrorModel({super.description, super.model});
}
