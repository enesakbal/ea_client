import 'interfaces/interface_client_model.dart';

class ClientConfig<T> {
  final String baseUrl;
  final InterfaceClientModel<T> errorModel;

  final String? token;
  final String? appName;
  final Map<String, dynamic>? headers;
  final bool logging;

  const ClientConfig({
    required this.baseUrl,
    required this.errorModel,
    this.token,
    this.appName,
    this.headers,
    this.logging = false,
  });
}
