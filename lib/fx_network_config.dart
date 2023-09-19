import 'interfaces/fx_interface_network_model.dart';

class FXNetworkConfig<E extends FXInterfaceNetworkModel<E>> {
  final String baseUrl;
  final String? token;
  final String? appName;
  final Map<String, dynamic>? headers;
  final bool logging;

  final E? errorModel;

  const FXNetworkConfig({
    required this.baseUrl,
    this.token,
    this.appName,
    this.headers,
    this.errorModel,
    this.logging = false,
  });
}
