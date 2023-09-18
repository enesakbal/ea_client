import '../../../../interfaces/fx_interface_network_model.dart';

class MetaModel implements FXInterfaceNetworkModel<MetaModel> {
  String? message;
  int? statusCode;

  MetaModel({this.message, this.statusCode});

  @override
  MetaModel fromJson(Map<String, dynamic> json) => MetaModel(
        message: json['message'] as String?,
        statusCode: json['status_code'] as int?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'message': message,
        'status_code': statusCode,
      };
}
