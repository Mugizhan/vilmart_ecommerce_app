import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

String _stringFromAny(dynamic value) => value?.toString() ?? '';
double _doubleFromAny(dynamic value) => (value is num) ? value.toDouble() : double.tryParse(value.toString()) ?? 0.0;
int _intFromAny(dynamic value) => (value is int) ? value : int.tryParse(value.toString()) ?? 0;

@JsonSerializable()
class UserProfile {
  @JsonKey(name: 'username')
  final String name;
  final String email;

  @JsonKey(name: 'number')
  final int phoneNumber;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class Shop {
  final String shopId;
  final String shopName;
  final String category;
  final String email;
  final String gst;

  @JsonKey(fromJson: _stringFromAny)
  final String phone;

  final String ownerId;
  final String ownerName;

  @JsonKey(fromJson: _stringFromAny)
  final String rating;

  final String shopImageLink;
  final Address address;
  final LatLon latlon;

  Shop({
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.email,
    required this.gst,
    required this.phone,
    required this.ownerId,
    required this.ownerName,
    required this.rating,
    required this.shopImageLink,
    required this.address,
    required this.latlon,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);
}

@JsonSerializable()
class Address {
  final String address;
  final String city;
  final String state;
  final String country;

  @JsonKey(fromJson: _stringFromAny)
  final String pincode;

  Address({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class LatLon {
  final double latitude;
  final double longitude;

  LatLon({
    required this.latitude,
    required this.longitude,
  });

  factory LatLon.fromJson(Map<String, dynamic> json) =>
      _$LatLonFromJson(json);

  Map<String, dynamic> toJson() => _$LatLonToJson(this);
}

@JsonSerializable()
class CartItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;

  CartItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

@JsonSerializable()
class Order {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double total;

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class CompleteUserData {
  final UserProfile userProfile;
  final List<Shop> userShops;
  final List<Order>? userOrders;

  CompleteUserData({
    required this.userProfile,
    required this.userShops,
    this.userOrders,
  });

  factory CompleteUserData.fromJson(Map<String, dynamic> json) =>
      _$CompleteUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteUserDataToJson(this);
}
