// import 'package:fx_network/core/clients/dio/dio_client.dart';
// import 'package:fx_network/core/clients/http/http_client.dart';
// import 'package:fx_network/core/enums/fx_request_methods.dart';
// import 'package:fx_network/core/models/fx_empty_model.dart';
// import 'package:fx_network/fx_network_config.dart';

// void main() async {
//   const config = FXNetworkConfig(
//     baseUrl: 'https://jsonplaceholder.typicode.com/todos/1',
//     appName: 'example',
//     headers: {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     },
//   );

//   final dioClient = DioClient<EmptyModel>(config: config);

//   final httpClient = HttpClient<EmptyModel>(config: config);

//   // final dioGet = await dioClient.send<PostModel, List<PostModel>>(
//   //   '/posts',
//   //   parseModel: PostModel(),
//   //   method: FXRequestMethods.GET,
//   // );

//   // final httpGet = await httpClient.send<PostModel, List<PostModel>>(
//   //   '/posts',
//   //   parseModel: PostModel(),
//   //   method: FXRequestMethods.GET,
//   // );

//   final dioPost = await dioClient.send<EmptyModel, EmptyModel>(
//     '/posts',
//     parseModel: EmptyModel(),
//     method: FXRequestMethods.POST,
//     data: {
//       'title': 'foo',
//       'body': 'bar',
//       'userId': 1,
//     },
//   );

//   final httpPost = await httpClient.send<EmptyModel, EmptyModel>(
//     '/posts',
//     parseModel: EmptyModel(),
//     method: FXRequestMethods.GET,
//   );
// }
