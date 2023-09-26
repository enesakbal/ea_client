// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'client_config.dart';
import 'clients/dio/dio_client.dart';
import 'clients/http/http_client.dart';
import 'core/base/base_ea_client.dart';
import 'core/enums/client_adapters.dart';

class EANetworkManager {
  static late final ClientConfig _config;

  static late final BaseEAClient _client;

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
