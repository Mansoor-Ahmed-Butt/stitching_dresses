import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  Product({required this.name, this.imagePath, required this.price, required this.expiryDate, this.ownerEmail});

  @HiveField(0)
  String name;

  @HiveField(1)
  String? imagePath;

  @HiveField(2)
  double price;

  @HiveField(3)
  DateTime expiryDate;

  @HiveField(4)
  String? ownerEmail;
}
