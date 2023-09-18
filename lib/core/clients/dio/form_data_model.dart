// import 'package:dio/dio.dart';

// import '../../../interfaces/fx_interface_network_model.dart';

// /// The `IFormDataModel` interface is used to convert a model into a `FormData` object.
// /// The `IFormDataModel` interface is implemented by the `INetworkModel` interface.
// /// It uses the `toJson` method from the `INetworkModel` interface to convert the model into a Map<String, dynamic>.
// mixin FormDataModel<T extends FXInterfaceNetworkModel<T>> on FXInterfaceNetworkModel<T> {
//   FormData? toFormData() {
//     try {
//       if (toJson() == null) return null;
//       return FormData.fromMap(toJson()!);
//     } catch (e) {
//       throw Exception('Error in FormData $e');
//     }
//   }
// }
