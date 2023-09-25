import 'core/models/error_model.dart';
import 'interfaces/interface_client_model.dart';

class ClientConfig<T extends InterfaceClientModel<T>> {
  final String baseUrl;
  final T errorModel;

  final String? appName;
  final Map<String, dynamic>? headers;
  final bool logging;

  const ClientConfig({
    required this.baseUrl,
    required this.errorModel,
    this.appName,
    this.headers,
    this.logging = false,
  });

  ErrorModel<T> generateErrorModel({
    String? description,
    int? statusCode,
    Map<String, dynamic>? jsonBody,
  }) {
    return ErrorModel<T>(description: description, statusCode: statusCode, model: errorModel.fromJson(jsonBody ?? {}));
  }
}
