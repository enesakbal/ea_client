import 'core/base/base_serializable_model.dart';
import 'core/enums/client_adapters.dart';
import 'core/error/network_exception.dart';
import 'core/models/error_model.dart';

class ClientConfig<E extends BaseSerializableModel<E>> {
  final String baseUrl;
  final E errorModel;
  final ClientAdapters adapter;

  final String? appName;
  final Map<String, dynamic>? headers;
  final bool logging;

  const ClientConfig({
    required this.baseUrl,
    required this.errorModel,
    required this.adapter,
    this.appName,
    this.headers,
    this.logging = false,
  });

  ErrorModel<E> generateErrorModel({
    NetworkException? error,
    Map<String, dynamic>? jsonBody,
  }) {
    return ErrorModel<E>(error: error, model: errorModel.fromJson(jsonBody ?? {}));
  }
}
