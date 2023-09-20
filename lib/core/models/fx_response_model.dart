import '../../interfaces/fx_interface_error_model.dart';
import '../../interfaces/fx_interface_network_model.dart';
import '../../interfaces/fx_interface_response_model.dart';

class ResponseModel<Response, Error extends FXInterfaceNetworkModel<Error>?>
    extends FXInterfaceResponseModel<Response?, Error> {
  ResponseModel({Response? data, FXInterfaceErrorModel<Error>? error, int? statusCode})
      : super(data, error, statusCode);
}
