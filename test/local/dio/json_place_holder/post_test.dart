import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/dio/dio_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../../_utils/models/post_model/post_model.dart';

void main() {
  late final FXNetworkManager dioClient;
  late final DioAdapter dioAdapter;
  late final FXNetworkConfig<EmptyModel> config;

  setUpAll(() {
    config = FXNetworkConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      appName: 'example',
      headers: {'content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
      // errorModelFromData: FXErrorModel().fromJson,
    );

    dioAdapter = DioAdapter(dio: Dio());

    dioClient = DioClient<EmptyModel>(config: config, adapter: dioAdapter);
  });

  group('[LOCAL] Dio [POST METHOD] on [Json Place Holder]', () {
    test('status code should return [201]', () async {
      dioAdapter.onPost(
        '/posts',
        (request) => request.reply(201, {'title': 'foo', 'body': 'bar', 'userId': 1}),
        data: {'title': 'foo', 'body': 'bar', 'userId': 1},
        headers: {'content-type': 'application/json; charset=UTF-8'},
      );

      final response = await dioClient.send<PostModel, PostModel>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.POST,
        data: {'title': 'foo', 'body': 'bar', 'userId': 1},
      );

      expect(response.statusCode, 201);
    });

    test('response data should return [PostModel]', () async {
      dioAdapter.onPost(
        '/posts',
        (request) => request.reply(201, {'title': 'foo', 'body': 'bar', 'userId': 1}),
        data: {'title': 'foo', 'body': 'bar', 'userId': 1},
        headers: {'content-type': 'application/json; charset=UTF-8'},
      );

      final response = await dioClient.send<PostModel, PostModel>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.POST,
        data: {
          'title': 'foo',
          'body': 'bar',
          'userId': 1,
        },
      );
      expect(response.data, isA<PostModel>());
    });

    test('status code should return [404]', () async {
      dioAdapter.onPost(
        '/ERROR',
        (request) => request.throws(
          404,
          DioException.badResponse(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/posts'),
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/posts'),
            ),
          ),
        ),
        headers: {'content-type': 'application/json; charset=UTF-8'},
      );

      final response = await dioClient.send<EmptyModel, EmptyModel>(
        '/ERROR',
        parseModel: EmptyModel(),
        method: FXRequestMethods.POST,
      );

      expect(response.statusCode, 404);
      expect(response.data, null);
    });
  });
}
