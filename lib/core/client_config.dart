import 'base/base_serializable_model.dart';
import 'enums/client_adapters.dart';
import 'error/network_exception.dart';
import 'models/_export_models.dart';

/// The `typedef` statement is used to create a type alias in Dart. In this case, it is creating a type
/// alias named `Empty` that takes a type parameter `T` which must extend the
/// `BaseSerializableModel<dynamic>` class. The `Empty` type alias is equivalent to
/// `EmptyErrorModel<T?>`.
typedef Empty<T extends BaseSerializableModel<dynamic>> = EmptyErrorModel<T?>;

/// The ClientConfig class is a generic class that takes a type parameter E which must extend the
/// BaseSerializableModel class.
class ClientConfig<E extends BaseSerializableModel<dynamic>> {
  final String baseUrl;
  E? errorModel;

  /// The `final ClientAdapters adapter;` line is declaring a final variable named `adapter` of type
  /// `ClientAdapters`. This variable is used to store the client adapter that will be used in the
  /// `ClientConfig` class.
  final ClientAdapters adapter;

  final String? appName;
  final Map<String, dynamic>? headers;
  final bool logging;

  ClientConfig({
    required this.baseUrl,
    required this.adapter,
    this.errorModel,
    this.appName,
    this.headers,
    this.logging = false,
  }) {
    errorModel ??= Empty<E>() as E;
  }

  /// The function generates an ErrorModel object by taking a NetworkException and a JSON body as input.
  ///
  /// Args:
  ///   error (NetworkException): The "error" parameter is of type NetworkException, which is an optional
  /// parameter. It represents the network exception that occurred.
  ///   jsonBody (Map<String, dynamic>): The `jsonBody` parameter is a map that represents the JSON
  /// response body received from a network request. It contains key-value pairs where the keys are
  /// strings and the values can be of any type.
  ///
  /// Returns:
  ///   an instance of the `ErrorModel` class with the specified `error` and `model` properties.
  ErrorModel<E> generateErrorModel({
    NetworkException? error,
    Map<String, dynamic>? jsonBody,
  }) {
    return ErrorModel<E>(error: error, model: errorModel?.fromJson(jsonBody ?? {}) as E);
  }
}
