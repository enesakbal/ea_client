import 'interfaces/fx_interface_network_model.dart';

class FXNetworkConfig<Error extends FXInterfaceNetworkModel<Error>> {
  final String baseUrl;
  final String? token;
  final String? appName;
  final Map<String, dynamic>? headers;
  final bool logging;

  final Error? errorModel;

  const FXNetworkConfig({
    required this.baseUrl,
    this.token,
    this.appName,
    this.headers,
    this.errorModel,
    this.logging = false,
  });
}
