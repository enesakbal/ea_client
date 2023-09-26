import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/fx_client.dart';

import '../_utils/models/post_model/post_model.dart';

void main() {
  late final BaseFXClient httpClient;

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

    final network = FXNetworkManager(config: config);

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

    //* Test [ServerExceptionType.connectionError]

    // test('status code should return [Socket Exception]', () async {
    //   try {
    //     await httpClient.send<PostModel, List<PostModel>>(
    //       '/posts',
    //       parserModel: PostModel(),
    //       method: RequestTypes.GET,
    //     );
    //   } on ErrorModel catch (e) {
    //     expect(e.error?.exceptionType, ServerExceptionType.socketException);
    //   }
    // });
  });
}
