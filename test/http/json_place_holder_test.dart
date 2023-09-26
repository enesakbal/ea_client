import 'package:ea_client/client_config.dart';
import 'package:ea_client/core/base/base_ea_client.dart';
import 'package:ea_client/core/enums/client_adapters.dart';
import 'package:ea_client/core/enums/request_types.dart';
import 'package:ea_client/core/enums/server_client_exceptions.dart';
import 'package:ea_client/core/models/error_model.dart';
import 'package:ea_client/ea_network_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../_utils/models/post_model/post_model.dart';

void main() {
  late final BaseEAClient httpClient;

  setUpAll(() {
    final config = ClientConfig(
      adapter: ClientAdapters.HTTP,
      baseUrl: 'https://jsonplaceholder.typicode.com',
      appName: 'example',
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    final network = EANetworkManager(config: config);

    httpClient = network.client;
  });
  group('[REMOTE] HTTP [GET METHOD] on [Json Place Holder]', () {
    test('status code should return [200]', () async {
      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/posts',
        parserModel: PostModel(),
        method: RequestTypes.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [List<PostModel>]', () async {
      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/posts',
        parserModel: PostModel(),
        method: RequestTypes.GET,
      );

      expect(response.data, isA<List<PostModel>>());
    });

    test('status code should return [404]', () async {
      try {
        await httpClient.send(
          '/postswe',
          parserModel: PostModel(),
          method: RequestTypes.GET,
        );

        // expect(response, isA<ErrorModel>());
      } on ErrorModel catch (e) {
        expect(e.error?.statusCode, 404);
        expect(e.error?.exceptionType, ServerExceptionType.notFound);
      }
    });
  });
}
