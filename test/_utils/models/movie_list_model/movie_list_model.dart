import 'package:fx_network/interfaces/fx_interface_network_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'movie_model.dart';

part 'movie_list_model.g.dart';

@JsonSerializable()
class MovieListModel extends FXInterfaceNetworkModel<MovieListModel> {
  int? page;
  List<MovieModel>? results;
  @JsonKey(name: 'total_pages')
  int? totalPages;
  @JsonKey(name: 'total_results')
  int? totalResults;

  MovieListModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieListModel.fromJson(Map<String, dynamic> json) {
    return _$MovieListModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$MovieListModelToJson(this);

  @override
  MovieListModel fromJson(Map<String, dynamic> json) {
    return _$MovieListModelFromJson(json);
  }
}
