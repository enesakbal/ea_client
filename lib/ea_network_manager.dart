import 'client_config.dart';
import 'clients/dio/dio_client.dart';
import 'clients/http/http_client.dart';
import 'core/base/base_ea_client.dart';
import 'core/enums/client_adapters.dart';

/// The `EANetworkManager` class is a Dart class that manages the network client based on the provided
/// configuration.

class EANetworkManager {
  static late final ClientConfig _config;

  static late final BaseEAClient _client;

  /// The function creates a network manager object based on the provided client configuration.
  ///
  /// Args:
  ///   config (ClientConfig): The `config` parameter is an instance of the `ClientConfig` class. It is
  /// required for initializing the `EANetworkManager` and contains configuration options for the network
  /// client.
  EANetworkManager({required ClientConfig config}) {
    _config = config;
    switch (_config.adapter) {
      case ClientAdapters.DIO:
        _client = DioClient(config: _config);
      case ClientAdapters.HTTP:
        _client = HttpClient(config: _config);
        break;
    }
  }

  BaseEAClient get client => _client;
}
