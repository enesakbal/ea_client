import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/dio/dio_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network.dart';
import 'package:fx_network/fx_network_config.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../../_utils/json_reader.dart';
import '../../../_utils/models/movie_list_model/movie_list_model.dart';
import '../../../_utils/models/movie_list_model/movie_model.dart';
import '../../../_utils/models/post_model/post_model.dart';
import '../../../_utils/models/tmdb_error_model/tmdb_error_model.dart';

void main() {
  late final FXNetworkManager dioClient;
  late final DioAdapter dioAdapter;
  late final Map<String, dynamic> movieModelList;
  late final FXNetworkConfig config;

  setUpAll(() {
    config = FXNetworkConfig<TmdbErrorModel>(
      logging: true,
      baseUrl: 'https://api.themoviedb.org/3',
      errorModel: TmdbErrorModel(),
      headers: {'content-type': 'application/json; charset=UTF-8'},
      token:
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZmFkZDliNzY5NTU2ZjQ1NWRjYmE2NGZlYzU2NmYxOCIsInN1YiI6IjY0MWQ5NGYyMzQ0YThlMDBiYTNjMDBiNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nofxbbCpeqzAJ_XCXwgvzKZrO_KQqgYIErKx8T-HvLc',
    );
    dioAdapter = DioAdapter(dio: Dio());

    dioClient = DioClient<TmdbErrorModel>(config: config, adapter: dioAdapter);

    movieModelList = readJson('dummy_movie_list.json') as Map<String, dynamic>;
  });

  group('[LOCAL] Dio [GET METHOD] on [TMDB]', () {
    test('status code should return [200]', () async {
      dioAdapter.onGet(
        '/authentication',
        (request) => request.reply(
          200,
          null,
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
          'content-type': 'application/json; charset=UTF-8'
        },
      );

      final response = await dioClient.send<EmptyModel, EmptyModel>(
        '/authentication',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
      expect(response.data, isA<EmptyModel>());
    });

    test('status code should return [404] && response error model should be [TmdbErrorModel]', () async {
      dioAdapter.onGet(
        '/wrongEndPoint',
        (request) => request.reply(
          404,
          TmdbErrorModel(statusCode: 404, statusMessage: 'message', success: false).toJson(),
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
          'content-type': 'application/json; charset=UTF-8'
        },
      );

      final response = await dioClient.send<EmptyModel, EmptyModel>(
        '/wrongEndPoint',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.statusCode);
      expect(response.statusCode, 404);
      expect(response.error?.model, isA<TmdbErrorModel>());
    });

    test('response data should return [MovieListModel]', () async {
      dioAdapter.onGet(
        '/discover/movie/',
        (request) => request.reply(200, movieModelList),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
          'content-type': 'application/json; charset=UTF-8'
        },
      );

      final response = await dioClient.send<MovieListModel, MovieListModel>('/discover/movie/',
          parseModel: MovieListModel(),
          method: FXRequestMethods.GET,
          queryParameters: {
            'include_adult': false,
            'include_video': false,
            'language': 'en-US',
            'page': 1,
            'sort_by': 'popularity.desc'
          });

      expect(response.data, isA<MovieListModel>());
      expect(response.data?.results?.first, isA<MovieModel>());
    });

    test('response error description should not null [isNotNull]', () async {
      dioAdapter.onGet(
        '/posts',
        (request) => request.reply(404, {'error'}),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${config.token}',
          'content-type': 'application/json; charset=UTF-8'
        },
      );
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/posts',
        parseModel: PostModel(),
        method: FXRequestMethods.GET,
      );
      expect(response.error?.description, isNotNull);
    });
  });
}
