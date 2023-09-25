import 'package:ea_client/client_config.dart';
import 'package:ea_client/clients/dio_client.dart';
import 'package:ea_client/core/enums/request_methods.dart';
import 'package:ea_client/core/models/error_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '_utils/models/post_model/post_model.dart';
import '_utils/models/tmdb_error_model/tmdb_error_model.dart';

void main() {
  late final DioClient dioClient;

  setUpAll(() {
    final config = ClientConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      appName: 'example',
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json; charset=UTF-8',
      },
      errorModel: TmdbErrorModel(),
    );

    dioClient = DioClient(config: config);
  });
  group('[REMOTE] Dio [GET METHOD] on [Json Place Holder]', () {
    test('status code should return [200]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: RequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [List<PostModel>]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: RequestMethods.GET,
      );

      expect(response.data, isA<List<PostModel>>());
    });

    test('status code should return [404]', () async {
      try {
        await dioClient.send(
          '/postswe',
          parseModel: PostModel(),
          method: RequestMethods.GET,
        );
        // expect(response, isA<ErrorModel>());
      } on ErrorModel<TmdbErrorModel> catch (e) {
        expect(e.model, 404);
      }
    });
  });
}
