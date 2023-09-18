import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/dio/dio_client.dart';
import 'package:fx_network/core/clients/dio/fx_error_model/fx_error_model.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';

import '../util/post_model.dart';

void main() {
  late final DioClient dioClient;

  setUpAll(() {
    final config = FXNetworkConfig<FxErrorModel>(
      // baseUrl: 'https://test.artyaiapp.com/app/login/',
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      appName: 'example',
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json; charset=UTF-8',
      },
      errorModel: FxErrorModel(),
    );

    dioClient = DioClient<FxErrorModel>(config: config);
  });
  group('Dio [GET METHOD]', () {
    test('status code should return [200]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [List<PostModel>]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isA<List<PostModel>>());
    });
  });
  group('Dio [POST METHOD] ', () {
    test('status code should return [201]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.POST,
      );

      expect(response.statusCode, 201);
    });

    test('response data should return [List<PostModel>]', () async {
      final response = await dioClient.send<EmptyModel, EmptyModel>(
        '/pojsts',
        parseModel: EmptyModel(),
        method: FXRequestMethods.POST,
        data: {
          'title': 'foo',
          'body': 'bar',
          'userId': 1,
        },
      );
      print(response.error?.model);
      print(response.error?.description);
      print(response.data);
      print(response.statusCode);
      print(response.error);
    });
  });
}
