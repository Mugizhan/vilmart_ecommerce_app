// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      name: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['number'] as int,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'username': instance.name,
      'email': instance.email,
      'number': instance.phoneNumber,
    };

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      category: json['category'] as String,
      email: json['email'] as String,
      gst: json['gst'] as String,
      phone: _stringFromAny(json['phone']),
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      rating: _stringFromAny(json['rating']),
      shopImageLink: json['shopImageLink'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      latlon: LatLon.fromJson(json['latlon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'category': instance.category,
      'email': instance.email,
      'gst': instance.gst,
      'phone': instance.phone,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'rating': instance.rating,
      'shopImageLink': instance.shopImageLink,
      'address': instance.address,
      'latlon': instance.latlon,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      pincode: _stringFromAny(json['pincode']),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
    };

LatLon _$LatLonFromJson(Map<String, dynamic> json) => LatLon(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLonToJson(LatLon instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'userId': instance.userId,
      'items': instance.items,
      'total': instance.total,
    };

CompleteUserData _$CompleteUserDataFromJson(Map<String, dynamic> json) =>
    CompleteUserData(
      userProfile:
          UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      userShops: (json['userShops'] as List<dynamic>)
          .map((e) => Shop.fromJson(e as Map<String, dynamic>))
          .toList(),
      userOrders: (json['userOrders'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompleteUserDataToJson(CompleteUserData instance) =>
    <String, dynamic>{
      'userProfile': instance.userProfile,
      'userShops': instance.userShops,
      'userOrders': instance.userOrders,
    };
