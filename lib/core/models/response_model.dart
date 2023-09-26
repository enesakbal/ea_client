import '../base/base_data_model.dart';

/// The `ResponseModel` class is a generic class that represents a response with optional data and
/// status code.
class ResponseModel<R> extends BaseDataModel<R?> {
  ResponseModel({R? data, int? statusCode}) : super(data, statusCode);
}
