import 'package:hive/hive.dart';

part 'Item_Model.g.dart';

@HiveType(typeId: 0)
class ItemModel extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? quantity;

  @HiveField(2)
  final String? unit;

  @HiveField(3)
  final String? price;

  @HiveField(4)
  final String? category;

  @HiveField(5)
  final bool? placeIntoCart;

  @HiveField(6)
  final String? note;

  @HiveField(7)
  final String? imagePath;

  @HiveField(8)
  final String? image;

  ItemModel({
    this.name,
    this.quantity,
    this.image,
    this.unit,
    this.price,
    this.category,
    this.placeIntoCart,
    this.note,
    this.imagePath,
  });
}
