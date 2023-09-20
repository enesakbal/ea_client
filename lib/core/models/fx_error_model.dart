import '../../interfaces/fx_interface_error_model.dart';
import '../../interfaces/fx_interface_network_model.dart';

class FXErrorModel<Error extends FXInterfaceNetworkModel<Error>?> extends FXInterfaceErrorModel<Error> {
  FXErrorModel({super.description, super.model});
}
