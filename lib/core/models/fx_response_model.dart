import '../../interfaces/fx_interface_error_model.dart';
import '../../interfaces/fx_interface_network_model.dart';
import '../../interfaces/fx_interface_response_model.dart';

class ResponseModel<T, E extends FXInterfaceNetworkModel<E>?> extends FXInterfaceResponseModel<T?, E> {
  ResponseModel({T? data, FXInterfaceErrorModel<E>? error, int? statusCode}) : super(data, error, statusCode);
}
