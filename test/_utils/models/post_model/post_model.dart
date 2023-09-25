import 'package:ea_client/core/base/base_serializable_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends BaseSerializableModel<PostModel> {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  PostModel({this.userId, this.id, this.title, this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return _$PostModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  @override
  PostModel fromJson(Map<String, dynamic> json) => PostModel.fromJson(json);
}
