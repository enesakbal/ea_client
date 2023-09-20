import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/http/http_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../_utils/json_reader.dart';
import '../../../_utils/models/post_model/post_model.dart';

void main() {
  late final FXNetworkConfig config;
  late final List<dynamic> postModelList;

  setUpAll(() {
    config = FXNetworkConfig<EmptyModel>(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      appName: 'example',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
    );

    postModelList = readJson('dummy_posts_list.json') as List<dynamic>;
  });

  group('[LOCAL] Http [GET METHOD] on [Json Place Holder]', () {
    test('status code should return [200]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/posts');

          return http.Response(
            jsonEncode(postModelList),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              'Accept': 'application/json',
              'Content-type': 'application/json; charset=UTF-8',
            },
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [List<PostModel>]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/posts');

          return http.Response(
            jsonEncode(postModelList),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              'Accept': 'application/json',
              'Content-type': 'application/json; charset=UTF-8',
            },
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isA<List<PostModel>>());
    });

    test('status code should return [404]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/wrongEndpoint');

          return http.Response(
            jsonEncode({'error': 'error'}),
            404,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              'Accept': 'application/json',
              'Content-type': 'application/json; charset=UTF-8',
            },
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/wrongEndpoint',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.error?.description);
      expect(response.statusCode, 404);
      expect(response.error?.description, isNotNull);
    });

    test("response error description should return ['No internet.']", () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/wrongEndpoint');

          return http.Response(
            jsonEncode({'error': 'error'}),
            404,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              'Accept': 'application/json',
              'Content-type': 'application/json; charset=UTF-8',
            },
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<PostModel, List<PostModel>>(
        '/wrongEndpoint',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.error?.description);
      expect(response.statusCode, 404);
      expect(response.error?.description, isNotNull);
    });
  });
}
