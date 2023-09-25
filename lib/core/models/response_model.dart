import '../../interfaces/interface_response_model.dart';

class ResponseModel<R> extends InterfaceResponseModel<R?> {
  ResponseModel({R? data, int? statusCode}) : super(data, statusCode);
}
