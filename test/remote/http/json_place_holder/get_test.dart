import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/http/http_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';

import '../../../_utils/models/post_model/post_model.dart';

void main() {
  late final HttpClient<EmptyModel> httpClient;
  late final FXNetworkConfig config;

  setUpAll(() {
    config = FXNetworkConfig<EmptyModel>(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      appName: 'example',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
    );

    httpClient = HttpClient(config: config);
  });

  group('[REMOTE] Http [GET METHOD] on [Json Place Holder]', () {
    test('status code should return [200]', () async {
      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [List<PostModel>]', () async {
      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isA<List<PostModel>>());
    });

    test('status code should return [404]', () async {
      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/wrongEndpoint',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.error?.description);
      expect(response.statusCode, 404);
    });
  });
}
