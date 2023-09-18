import '../../../../interfaces/fx_interface_network_model.dart';
import 'meta_model.dart';

class FxErrorModel extends FXInterfaceNetworkModel<FxErrorModel> {
  MetaModel? metaModel;

  FxErrorModel({this.metaModel});

  @override
  Map<String, dynamic> toJson() => {
        'meta': metaModel?.toJson(),
      };

  @override
  FxErrorModel fromJson(Map<String, dynamic> json) {
    return FxErrorModel(
      metaModel: json['meta'] == null ? null : metaModel?.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}
