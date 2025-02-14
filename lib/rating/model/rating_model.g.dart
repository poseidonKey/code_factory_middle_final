// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
      json['id'] as String,
      UserModel.fromJson(json['user'] as Map<String, dynamic>),
      (json['rating'] as num).toInt(),
      json['content'] as String,
      DataUtils.listPathsToUrls(json['imgUrls'] as List),
    );

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'rating': instance.rating,
      'content': instance.content,
      'imgUrls': instance.imgUrls,
    };
