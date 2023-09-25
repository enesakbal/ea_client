import 'package:ea_client/interfaces/interface_client_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tmdb_error_model.g.dart';

@JsonSerializable()
class TmdbErrorModel extends InterfaceClientModel<TmdbErrorModel> {
  @JsonKey(name: 'status_code')
  int? statusCode;
  @JsonKey(name: 'status_message')
  String? statusMessage;
  bool? success;

  TmdbErrorModel({this.statusCode, this.statusMessage, this.success});

  factory TmdbErrorModel.fromJson(Map<String, dynamic> json) {
    return _$TmdbErrorModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$TmdbErrorModelToJson(this);

  @override
  TmdbErrorModel fromJson(Map<String, dynamic> json) {
    return _$TmdbErrorModelFromJson(json);
  }
}
