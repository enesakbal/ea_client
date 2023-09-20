import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/http/http_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../_utils/models/post_model/post_model.dart';

void main() {
  late final FXNetworkConfig config;

  setUpAll(() {
    config = FXNetworkConfig<EmptyModel>(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      appName: 'example',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
      // errorModelFromData: FXErrorModel().fromJson,
    );
  });

  group('[LOCAL] Http [POST METHOD] on [Json Place Holder]', () {
    test('status code should return [201]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/posts');

          return http.Response(
            jsonEncode(PostModel(title: 'foo', body: 'bar', userId: 1)),
            201,
            request: http.Request(FXRequestMethods.POST.stringValue, uri),
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

      final response = await httpClient.send<PostModel, PostModel>(
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
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/posts');

          return http.Response(
            jsonEncode(PostModel(title: 'foo', body: 'bar', userId: 1)),
            201,
            request: http.Request(FXRequestMethods.POST.stringValue, uri),
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

      final response = await httpClient.send<PostModel, PostModel>(
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
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/ERROR');

          return http.Response(
            jsonEncode({'error': 'error'}),
            404,
            request: http.Request(FXRequestMethods.POST.stringValue, uri),
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

      final response = await httpClient.send<EmptyModel, EmptyModel>(
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
