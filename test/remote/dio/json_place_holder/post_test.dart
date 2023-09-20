import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/dio/dio_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';

import '../../../_utils/models/post_model/post_model.dart';

void main() {
  late final DioClient<EmptyModel> dioClient;

  setUpAll(() {
    final config = FXNetworkConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      appName: 'example',
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json; charset=UTF-8',
      },
      errorModel: EmptyModel(),
      // errorModelFromData: FXErrorModel().fromJson,
    );

    dioClient = DioClient(config: config);
  });

  group('[REMOTE] Dio [POST METHOD] on [Json Place Holder]', () {
    test('status code should return [201]', () async {
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

      expect(response.statusCode, 201);
    });

    test('response data should return [PostModel]', () async {
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
      final response = await dioClient.send<EmptyModel, EmptyModel>(
        '/ERROR',
        parseModel: EmptyModel(),
        method: FXRequestMethods.POST,
        data: {
          'title': 'foo',
          'body': 'bar',
          'userId': 1,
        },
      );

      expect(response.statusCode, 404);
      expect(response.data, null);
    });
  });
}
