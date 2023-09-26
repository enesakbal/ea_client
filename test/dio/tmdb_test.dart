import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/fx_client.dart';

import '../_utils/models/movie_list_model/movie_list_model.dart';
import '../_utils/models/movie_list_model/movie_model.dart';
import '../_utils/models/post_model/post_model.dart';
import '../_utils/models/tmdb_error_model/tmdb_error_model.dart';

void main() {
  late final BaseFXClient dioClient;
  late final ClientConfig<TmdbErrorModel> config;

  setUpAll(() {
    config = ClientConfig(
      adapter: ClientAdapters.DIO,
      logging: true,
      baseUrl: 'https://api.themoviedb.org/3',
      errorModel: TmdbErrorModel(),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZmFkZDliNzY5NTU2ZjQ1NWRjYmE2NGZlYzU2NmYxOCIsInN1YiI6IjY0MWQ5NGYyMzQ0YThlMDBiYTNjMDBiNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nofxbbCpeqzAJ_XCXwgvzKZrO_KQqgYIErKx8T-HvLc'
      },
    );

    final network = FXNetworkManager(config: config);

    dioClient = network.client;
  });

  group('[REMOTE] Dio [GET METHOD] on [TMDB]', () {
    test('status code should return [200]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/authentication',
        method: RequestTypes.GET,
        parserModel: PostModel(),
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [MovieListModel]', () async {
      final response = await dioClient.send<MovieListModel, MovieListModel>('/discover/movie/',
          parserModel: MovieListModel(),
          method: RequestTypes.GET,
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

    test('status code should return [404]', () async {
      try {
        await dioClient.send(
          '/authenticasdtion',
          parserModel: MovieListModel(),
          method: RequestTypes.GET,
        );
      } on ErrorModel<TmdbErrorModel> catch (e) {
        expect(e.model, isNotNull);
        expect(e.model, isA<TmdbErrorModel>());

        expect(e.model?.success, false);

        expect(e.error?.exceptionType, ServerExceptionType.notFound);
        expect(e.error?.statusCode, 404);
      }
    });
    test('status code should return [401]', () async {
      try {
        final config = ClientConfig(
          adapter: ClientAdapters.DIO,
          logging: true,
          baseUrl: 'https://api.themoviedb.org/3',
          errorModel: TmdbErrorModel(),
          headers: {HttpHeaders.authorizationHeader: 'Bearer WRONG TOKEN.nofxbbCpeqzAJ_XCXwgvzKZrO_KQqgYIErKx8T-HvLc'},
        );

        final dioClient = DioClient(config: config);

        await dioClient.send(
          '/authentication',
          parserModel: MovieListModel(),
          method: RequestTypes.GET,
        );
      } on ErrorModel<TmdbErrorModel> catch (e) {
        expect(e.model, isNotNull);
        expect(e.model, isA<TmdbErrorModel>());

        expect(e.model?.statusMessage, 'Invalid API key: You must be granted a valid key.');
        expect(e.model?.success, false);

        expect(e.error?.exceptionType, ServerExceptionType.unauthorisedRequest);
        expect(e.error?.statusCode, 401);
      }
    });
  });
}
