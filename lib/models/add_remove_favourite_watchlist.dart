import 'dart:convert';

AddRemoveFavWatchtlistModel addRemoveFavWatchtlistModelFromJson(String str) => AddRemoveFavWatchtlistModel.fromJson(json.decode(str));

String addRemoveFavWatchtlistModelToJson(AddRemoveFavWatchtlistModel data) => json.encode(data.toJson());

class AddRemoveFavWatchtlistModel {
  bool success;
  int statusCode;
  String statusMessage;

  AddRemoveFavWatchtlistModel({
    required this.success,
    required this.statusCode,
    required this.statusMessage,
  });

  factory AddRemoveFavWatchtlistModel.fromJson(Map<String, dynamic> json) => AddRemoveFavWatchtlistModel(
    success: json["success"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}