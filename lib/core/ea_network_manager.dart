import '../clients/dio/dio_client.dart';
import '../clients/http/http_client.dart';
import 'base/base_ea_client.dart';
import 'client_config.dart';
import 'enums/client_adapters.dart';

/// The `EANetworkManager` class is a Dart class that manages the network client based on the provided
/// The line `library ea_network;` is declaring the Dart library name as "ea_network". This allows other
/// Dart files to import and use the classes and functions defined in this library.
/// configuration.

class EANetworkManager {
  late final ClientConfig _config;

  late final BaseEAClient _client;

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
