import 'package:ea_client/client_config.dart';
import 'package:ea_client/clients/dio_client.dart';
import 'package:ea_client/core/enums/request_methods.dart';
import 'package:ea_client/core/models/error_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '_utils/models/movie_list_model/movie_list_model.dart';
import '_utils/models/movie_list_model/movie_model.dart';
import '_utils/models/post_model/post_model.dart';
import '_utils/models/tmdb_error_model/tmdb_error_model.dart';

void main() {
  late final DioClient dioClient;
  late final ClientConfig<TmdbErrorModel> config;

  setUpAll(() {
    config = ClientConfig(
      logging: true,
      baseUrl: 'https://api.themoviedb.org/3',
      errorModel: TmdbErrorModel(),
      token:
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZmFkZDliNzY5NTU2ZjQ1NWRjYmE2NGZlYzU2NmYxOCIsInN1YiI6IjY0MWQ5NGYyMzQ0YThlMDBiYTNjMDBiNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nofxbbCpeqzAJ_XCXwgvzKZrO_KQqgYIErKx8T-HvLc',
    );

    dioClient = DioClient(config: config);
  });

  group('[REMOTE] Dio [GET METHOD] on [TMDB]', () {
    test('status code should return [200]', () async {
      final response = await dioClient.send<PostModel, List<PostModel>>(
        '/authentication',
        method: RequestMethods.GET,
      );

      expect(response.statusCode, 200);
    });

    test('response data should return [MovieListModel]', () async {
      final response = await dioClient.send<MovieListModel, MovieListModel>('/discover/movie/',
          parseModel: MovieListModel(),
          method: RequestMethods.GET,
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
          parseModel: MovieListModel(),
          method: RequestMethods.GET,
        );
      } on ErrorModel<TmdbErrorModel> catch (e) {
        expect(e.model, 404);
      }
    });

    // test('should not be null [TmdbErrorModel]', () async {
    //   final response = await dioClient.send<EmptyModel, EmptyModel>(
    //     '/authenticasdtion',
    //     parseModel: EmptyModel(),
    //     method: FXRequestMethods.GET,
    //   );
    //   expect(response.error, isNotNull);
    // });

    // test('error should be [TmdbErrorModel]', () async {
    //   final response = await dioClient.send<EmptyModel, EmptyModel>(
    //     '/authenticasdtion',
    //     parseModel: EmptyModel(),
    //     method: FXRequestMethods.GET,
    //   );

    //   // print(response.error?.model);
    //   expect(response.error?.model, isA<TmdbErrorModel>());
    // });

    // test('should not be null [TmdbErrorModel.statusMessage]', () async {
    //   final response = await dioClient.send<EmptyModel, EmptyModel>(
    //     '/authenticasdtion',
    //     parseModel: EmptyModel(),
    //     method: FXRequestMethods.GET,
    //   );

    //   expect(response.error?.model?.statusMessage, isNotNull);
    // });
  });
}
