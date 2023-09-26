import '../clients/dio/dio_client.dart';
import '../clients/http/http_client.dart';
import 'base/base_fx_client.dart';
import 'client_config.dart';
import 'enums/client_adapters.dart';

/// The `FXNetworkManager` class is a Dart class that manages the network client based on the provided
/// The line `library fx_network;` is declaring the Dart library name as "fx_network". This allows other
/// Dart files to import and use the classes and functions defined in this library.
/// configuration.

class FXNetworkManager {
  late final ClientConfig _config;

  late final BaseFXClient _client;

  /// The function creates a network manager object based on the provided client configuration.
  ///
  /// Args:
  ///   config (ClientConfig): The `config` parameter is an instance of the `ClientConfig` class. It is
  /// required for initializing the `FXNetworkManager` and contains configuration options for the network
  /// client.
  FXNetworkManager({required ClientConfig config}) {
    _config = config;
    switch (_config.adapter) {
      case ClientAdapters.DIO:
        _client = DioClient(config: _config);
      case ClientAdapters.HTTP:
        _client = HttpClient(config: _config);
        break;
    }
  }

  BaseFXClient get client => _client;
}
