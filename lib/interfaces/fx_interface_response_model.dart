import 'fx_interface_error_model.dart';
import 'fx_interface_network_model.dart';

abstract class FXInterfaceResponseModel<T, E extends FXInterfaceNetworkModel<E>?> {
  T? data;
  FXInterfaceErrorModel<E>? error;
  int? statusCode;

  FXInterfaceResponseModel(this.data, this.error, this.statusCode);
}
