// ignore_for_file: unused_field
import '../client_config.dart';
import '../enums/request_types.dart';
import '_export_base.dart';

/// The NetworkManager class is an abstract class that defines a contract for managing network operations with models that
/// implement the NetworkManager interface.
abstract class BaseFXClient {
  late final ClientConfig _config;

  BaseFXClient({required ClientConfig config}) : _config = config;

  /// The `send` method is used to send an HTTP request to a specified `path` with various parameters. Here is a breakdown of
  /// the parameters:
  Future<BaseDataModel<R?>> send<P extends BaseSerializableModel<P>, R>(
    String path, {
    required P parserModel,
    required RequestTypes method,
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}
