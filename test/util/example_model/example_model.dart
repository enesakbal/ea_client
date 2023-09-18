import 'package:fx_network/interfaces/fx_interface_network_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'example_model.g.dart';

@JsonSerializable()
class ExampleModel extends FXInterfaceNetworkModel<ExampleModel> {
  int? id;

  ExampleModel({this.id});

  @override
  Map<String, dynamic> toJson() => _$ExampleModelToJson(this);

  @override
  ExampleModel fromJson(Map<String, dynamic> json) {
    return _$ExampleModelFromJson(json);
  }
}
