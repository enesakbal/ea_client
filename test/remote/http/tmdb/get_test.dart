import 'package:flutter_test/flutter_test.dart';
import 'package:fx_network/core/clients/http/http_client.dart';
import 'package:fx_network/core/enums/fx_request_methods.dart';
import 'package:fx_network/core/models/fx_empty_model.dart';
import 'package:fx_network/fx_network_config.dart';

import '../../../_utils/models/movie_list_model/movie_list_model.dart';
import '../../../_utils/models/movie_list_model/movie_model.dart';
import '../../../_utils/models/tmdb_error_model/tmdb_error_model.dart';

void main() {
  late final HttpClient<TmdbErrorModel> httpClient;
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
    httpClient = HttpClient(config: config);
  });

  group('[REMOTE] Http [GET METHOD] on [TMDB]', () {
    test('status code should return [200]', () async {
      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/authentication',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [MovieListModel]', () async {
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

      expect(response.data, isA<MovieListModel>());
      expect(response.data?.results?.first, isA<MovieModel>());
    });

    test('status code should return [404]', () async {
      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/wrongEndPoint',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.statusCode);
      expect(response.statusCode, 404);
    });

    test('should not be null [TmdbErrorModel]', () async {
      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/authenticasdtion',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );
      expect(response.error, isNotNull);
    });

    test('error should be [TmdbErrorModel]', () async {
      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/authenticasdtion',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      // print(response.error?.model);
      expect(response.error?.model, isA<TmdbErrorModel>());
    });

    test('should not be null [TmdbErrorModel.statusMessage]', () async {
      final response = await httpClient.send<EmptyModel, EmptyModel>(
        '/authenticasdtion',
        parseModel: EmptyModel(),
        method: FXRequestMethods.GET,
      );

      expect(response.error?.model?.statusMessage, isNotNull);
    });
  });
}
