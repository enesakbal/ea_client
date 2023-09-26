/// The `BaseDataModel` class is an abstract class that represents a data model with a generic data type
/// `D`, and includes properties for the data and status code.
abstract class BaseDataModel<D> {
  D? data;
  int? statusCode;

  BaseDataModel(this.data, this.statusCode);
}
