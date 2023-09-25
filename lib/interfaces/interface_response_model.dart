abstract class InterfaceResponseModel<R> {
  R? data;
  int? statusCode;

  InterfaceResponseModel(this.data, this.statusCode);
}
