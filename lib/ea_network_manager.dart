// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'client_config.dart';
import 'clients/dio_client.dart';
import 'core/base/base_ea_client.dart';
import 'core/enums/client_adapters.dart';

class EANetworkManager {
  static late final ClientConfig _config;

  static late final BaseEAClient _dioClient;

  EANetworkManager({required ClientConfig config}) {
    _config = config;
    switch (_config.adapter) {
      case ClientAdapters.DIO:
        _dioClient = DioClient(config: _config);
      case ClientAdapters.HTTP:
        _dioClient = DioClient(config: _config);
        break;
    }
  }

  BaseEAClient get client => _config.adapter == ClientAdapters.DIO ? _dioClient : _dioClient;
}
