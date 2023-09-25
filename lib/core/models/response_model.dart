import '../base/base_data_model.dart';

class ResponseModel<R> extends BaseDataModel<R?> {
  ResponseModel({R? data, int? statusCode}) : super(data, statusCode);
}
