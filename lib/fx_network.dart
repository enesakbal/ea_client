import 'core/enums/fx_request_methods.dart';
import 'fx_network_config.dart';
import 'interfaces/fx_interface_network_model.dart';
import 'interfaces/fx_interface_response_model.dart';

/// The FXNetworkManager class is an abstract class that defines a contract for managing network operations with models that
/// implement the FXNetworkManager interface.
abstract class FXNetworkManager<E extends FXInterfaceNetworkModel<E>?> {
  final FXNetworkConfig config;

  const FXNetworkManager({required this.config});

  /// The `send` method is used to send an HTTP request to a specified `path` with various parameters. Here is a breakdown of
  /// the parameters:
  Future<FXInterfaceResponseModel<R?, E?>> send<T extends FXInterfaceNetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required FXRequestMethods method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
