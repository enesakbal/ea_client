abstract class BaseDataModel<D> {
  D? data;
  int? statusCode;

  BaseDataModel(this.data, this.statusCode);
}
