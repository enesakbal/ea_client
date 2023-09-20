import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/dio/dio_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../../_utils/json_reader.dart';
import '../../../_utils/models/post_model/post_model.dart';

void main() {
  late final FXNetworkManager client;
  late final FXNetworkConfig config;
  late final DioAdapter dioAdapter;
  late final List<dynamic> postModelList;

  setUpAll(() {
    config = FXNetworkConfig<EmptyModel>(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      appName: 'example',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
    );

    dioAdapter = DioAdapter(dio: Dio());

    client = DioClient<EmptyModel>(config: config, adapter: dioAdapter);

    postModelList = readJson('dummy_posts_list.json') as List<dynamic>;
  });

  group('[LOCAL] Dio [GET METHOD] on [Json Place Holder]', () {
    test('status code should return [200]', () async {
      dioAdapter.onGet(
        '/posts',
        (request) => request.reply(200, postModelList),
      );

      final response = await client.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [List<PostModel>]', () async {
      dioAdapter.onGet(
        '/posts',
        (request) => request.reply(200, postModelList),
      );

      final response = await client.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isA<List<PostModel>>());
    });

    test('status code should return [404]', () async {
      dioAdapter.onGet(
        '/posts',
        (request) => request.reply(404, {'error': 'error'}),
      );

      final response = await client.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );
      expect(response.statusCode, 404);
    });

    test('response error model should be [null]', () async {
      dioAdapter.onGet(
        '/posts',
        (request) => request.reply(404, null),
      );

      final response = await client.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );
      expect(response.error?.model, null);
    });

    test('response error description should not null [isNotNull]', () async {
      dioAdapter.onGet(
        '/posts',
        (request) => request.reply(404, {'error'}),
      );

      final response = await client.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );
      expect(response.error?.description, isNotNull);
    });
  });
}
