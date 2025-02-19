import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable()
class PostOrderBody {
  final String id;
  final int totalPrice;
  final String createdAt;
  final List<PostOrderBodyProduct> products;

  PostOrderBody({
    required this.id,
    required this.totalPrice,
    required this.createdAt,
    required this.products,
  });

  factory PostOrderBody.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable()
class PostOrderBodyProduct {
  final String productId;
  final int count;

  PostOrderBodyProduct({
    required this.productId,
    required this.count,
  });

  factory PostOrderBodyProduct.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyProductFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyProductToJson(this);
}
