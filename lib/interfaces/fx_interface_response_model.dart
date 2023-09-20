import 'fx_interface_error_model.dart';
import 'fx_interface_network_model.dart';

abstract class FXInterfaceResponseModel<Response, Error extends FXInterfaceNetworkModel<Error>?> {
  Response? data;
  FXInterfaceErrorModel<Error>? error;
  int? statusCode;

  FXInterfaceResponseModel(this.data, this.error, this.statusCode);
}
