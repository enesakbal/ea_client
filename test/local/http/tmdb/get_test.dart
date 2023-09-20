import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/http/http_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../_utils/json_reader.dart';
import '../../../_utils/models/movie_list_model/movie_list_model.dart';
import '../../../_utils/models/movie_list_model/movie_model.dart';
import '../../../_utils/models/tmdb_error_model/tmdb_error_model.dart';

void main() {
  late final Map<String, dynamic> movieModelList;
  late final FXNetworkConfig config;

  setUpAll(() {
    config = FXNetworkConfig<TmdbErrorModel>(
      logging: true,
      baseUrl: 'https://api.themoviedb.org/3',
      errorModel: TmdbErrorModel(),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      token:
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZmFkZDliNzY5NTU2ZjQ1NWRjYmE2NGZlYzU2NmYxOCIsInN1YiI6IjY0MWQ5NGYyMzQ0YThlMDBiYTNjMDBiNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nofxbbCpeqzAJ_XCXwgvzKZrO_KQqgYIErKx8T-HvLc',
    );

    movieModelList = readJson('dummy_movie_list.json') as Map<String, dynamic>;
  });

  group('[LOCAL] Http [GET METHOD] on [TMDB]', () {
    test('status code should return [200]', () async {
      late final MockClient mockClient;
      late final HttpClient<TmdbErrorModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/authentication');

          return http.Response(
            jsonEncode({'success': 'success'}),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
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
        '/authentication',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
      expect(response.data, isA<EmptyModel>());
    });

    test('status code should return [404] && response error model should be [TmdbErrorModel]', () async {
      late final MockClient mockClient;
      late final HttpClient<TmdbErrorModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/wrongEndPoint');

          return http.Response(
            jsonEncode(TmdbErrorModel(statusCode: 404, statusMessage: 'not found', success: false).toJson()),
            404,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
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
        '/wrongEndPoint',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.statusCode);
      expect(response.statusCode, 404);
      expect(response.error?.model, isA<TmdbErrorModel>());
    });

    test('response data should return [MovieListModel]', () async {
      late final MockClient mockClient;
      late final HttpClient<TmdbErrorModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/discover/movie/')
            ..replace(
              queryParameters: {
                'include_adult': false,
                'include_video': false,
                'language': 'en-US',
                'page': 1,
                'sort_by': 'popularity.desc'
              }..updateAll((key, value) => value.toString()),
            );
          return http.Response(
            jsonEncode(MovieListModel.fromJson(movieModelList).toJson()),
            200,
            request: http.Request(FXRequestMethods.GET.stringValue, uri),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
              HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
            },
          );
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<MovieListModel, MovieListModel>('/discover/movie/',
          parseModel: MovieListModel(),
          method: FXRequestMethods.GET,
          queryParameters: {
            'include_adult': false,
            'include_video': false,
            'language': 'en-US',
            'page': 1,
            'sort_by': 'popularity.desc'
          });

      expect(response.statusCode, 200);
      expect(response.data, isA<MovieListModel>());
      expect(response.data?.results?.first, isA<MovieModel>());
    });

    test('response error description should not null [isNotNull]', () async {
      late final MockClient mockClient;
      late final HttpClient<TmdbErrorModel> httpClient;

      mockClient = MockClient(
        (request) async {
          final uri = Uri.parse('${config.baseUrl}/authenticasdtion');

          return http.Response(
              jsonEncode(TmdbErrorModel(statusCode: 404, statusMessage: 'not found', success: false).toJson()), 404,
              request: http.Request(FXRequestMethods.GET.stringValue, uri),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
                HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
              },
              reasonPhrase: 'error');
        },
      );

      httpClient = HttpClient(
        config: config,
        isTesting: true,
        mockClient: mockClient,
      );

      final response = await httpClient.send<MovieListModel, MovieListModel>(
        '/authenticasdtion',
        parseModel: MovieListModel(),
        method: FXRequestMethods.GET,
      );
      expect(response.error?.description, isNotNull);
      expect(response.error?.model?.statusMessage, 'not found');
      expect(response.statusCode, 404);
    });
  });
}
