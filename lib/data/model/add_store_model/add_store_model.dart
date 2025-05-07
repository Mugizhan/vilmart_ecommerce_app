import 'package:json_annotation/json_annotation.dart';

part 'add_store_model.g.dart';

@JsonSerializable()
class AddStoreModel {
  final String category;
  final String shopName;
  final String ownerName;
  final String phone;
  final String email;
  final LatLonModel latlon;
  final AddressModel address;
  final String gst;

  AddStoreModel({
    required this.category,
    required this.shopName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.latlon,
    required this.address,
    required this.gst,
  });

  factory AddStoreModel.fromJson(Map<String, dynamic> json) => _$AddStoreModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddStoreModelToJson(this);
}

@JsonSerializable()
class AddressModel {
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;

  AddressModel({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
class LatLonModel {
  final double latitude;
  final double longitude;

  LatLonModel({
    required this.latitude,
    required this.longitude,
  });

  factory LatLonModel.fromJson(Map<String, dynamic> json) => _$LatLonModelFromJson(json);
  Map<String, dynamic> toJson() => _$LatLonModelToJson(this);
}
