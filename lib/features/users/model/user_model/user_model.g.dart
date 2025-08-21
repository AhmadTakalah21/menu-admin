// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: (json['role'] as num).toInt(),
      phone: json['phone'] as String,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
      address: json['address'] as String?,
      restaurantId: (json['restaurant_id'] as num).toInt(),
      status: json['status'] as String?,
      isActive: const BoolConverter().fromJson(json['is_active']),
      token: json['token'] as String?,
      image: json['image'] as String,
      restaurantLongitude: json['restaurant_longitude'] as String?,
      restaurantLatitude: json['restaurant_latitude'] as String?,
      distance: json['distance'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'phone': instance.phone,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'address': instance.address,
      'restaurant_id': instance.restaurantId,
      'status': instance.status,
      'is_active': const BoolConverter().toJson(instance.isActive),
      'token': instance.token,
      'image': instance.image,
      'restaurant_longitude': instance.restaurantLongitude,
      'restaurant_latitude': instance.restaurantLatitude,
      'distance': instance.distance,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
