// ignore_for_file: prefer_void_to_null

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/http/http_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late final FXNetworkConfig config;

  setUpAll(() {
    config = FXNetworkConfig<EmptyModel>(
      baseUrl: 'https://example.api.com/',
      appName: 'example',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      errorModel: EmptyModel(),
    );
  });

  group('[LOCAL] Dio [GET METHOD] on [Custom Tests]', () {
    test('status code should return [200]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            jsonEncode({'success': 'success'}),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [true]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            true.toString(),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, true);
    });

    test('response data should return [false]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            false.toString(),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, false);
    });

    test('response data should return [null]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            null.toString(),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, Null>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, null);
    });

    test('response data should return [null (Empty Map)]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            null.toString(),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, Map<String, dynamic>>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isNull);
    });

    test('response data should return [EmptyModel]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            {}.toString(),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isA<EmptyModel>());
    });
  });

  group('[LOCAL] Dio [PATCH METHOD] on [Custom Tests]', () {
    test('status code should return [200]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            {}.toString(),
            200,
            request: http.Request(FXRequestMethods.PATCH.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [true]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            true.toString(),
            200,
            request: http.Request(FXRequestMethods.PATCH.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, true);
    });

    test('response data should return [false]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            false.toString(),
            200,
            request: http.Request(FXRequestMethods.PATCH.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, bool>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, false);
    });

    test('response data should return [null]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            null.toString(),
            200,
            request: http.Request(FXRequestMethods.PATCH.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, Null>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
      );

      expect(response.data, null);
    });

    test('response data should return [null (Empty Map)]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            {}.toString(),
            200,
            request: http.Request(FXRequestMethods.PATCH.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<EmptyModel, Map<String, dynamic>>(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.data, isNull);
    });

    test('response data should return [EmptyModel]', () async {
      late final MockClient mockClient;
      late final HttpClient<EmptyModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/example');

          return http.Response(
            {}.toString(),
            200,
            request: http.Request(FXRequestMethods.PATCH.stringValue, uri),
            headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send(
        '/example',
        parseModel: EmptyModel(),
        method: FXRequestMethods.PATCH,
        data: {'patch': 'patch data'},
      );

      expect(response.data, isA<EmptyModel>());
    });
  });
}
