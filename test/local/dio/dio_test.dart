// ignore_for_file: prefer_void_to_null

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/dio/dio_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late final FXNetworkManager client;
  late final FXNetworkConfig config;
  late final DioAdapter dioAdapter;

  setUpAll(() {
    config = FXNetworkConfig<EmptyModel>(
      baseUrl: 'https://example.api.com/',
      appName: 'example',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
    );

    dioAdapter = DioAdapter(dio: Dio());

    client = DioClient<EmptyModel>(config: config, adapter: dioAdapter);
  });

  group('[LOCAL] Dio [GET METHOD] on [Custom Tests]', () {
    test('status code should return [200]', () async {
      dioAdapter.onGet(
        '/example',
        (request) => request.reply(200, null),
      );

      final response = await client.send<EmptyModel, EmptyModel>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });
    test('response data should return [true]', () async {
      dioAdapter.onGet(
        '/example',
        (request) => request.reply(200, true),
      );

      final response = await client.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, true);
    });
    test('response data should return [false]', () async {
      dioAdapter.onGet(
        '/example',
        (request) => request.reply(200, false),
      );

      final response = await client.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, false);
    });

    test('response data should return [null]', () async {
      dioAdapter.onGet(
        '/example',
        (request) => request.reply(200, null),
      );

      final response = await client.send<EmptyModel, Null>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, null);
    });

    test('response data should return [null (Empty Map)]', () async {
      dioAdapter.onGet(
        '/example',
        (request) => request.reply(200, {}),
      );

      final response = await client.send<EmptyModel, Map<String, dynamic>>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isNull);
    });

    test('response data should return [EmptyModel]', () async {
      dioAdapter.onGet(
        '/example',
        (request) => request.reply(200, {}),
      );

      final response = await client.send(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isA<EmptyModel>());
    });
  });

  group('[LOCAL] Dio [PATCH METHOD] on [Custom Tests]', () {
    test('status code should return [200]', () async {
      dioAdapter.onPatch(
        '/example',
        (request) => request.reply(200, null),
      );

      final response = await client.send<EmptyModel, EmptyModel>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.statusCode, 200);
    });
    test('response data should return [true]', () async {
      dioAdapter.onPatch(
        '/example',
        (request) => request.reply(200, true),
      );

      final response = await client.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, true);
    });
    test('response data should return [false]', () async {
      dioAdapter.onPatch(
        '/example',
        (request) => request.reply(200, false),
      );

      final response = await client.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, false);
    });

    test('response data should return [null]', () async {
      dioAdapter.onPatch(
        '/example',
        (request) => request.reply(200, null),
      );

      final response = await client.send<EmptyModel, Null>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, null);
    });

    test('response data should return [null (Empty Map)]', () async {
      dioAdapter.onPatch(
        '/example',
        (request) => request.reply(200, {}),
      );

      final response = await client.send<EmptyModel, Map<String, dynamic>>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, isNull);
    });

    test('response data should return [EmptyModel]', () async {
      dioAdapter.onPatch(
        '/example',
        (request) => request.reply(200, {}),
        data: {'patch': 'patch data'},
      );

      final response = await client.send(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
        data: {'patch': 'patch data'},
      );

      expect(response.data, isA<EmptyModel>());
    });
  });
}
