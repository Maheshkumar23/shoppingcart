import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shoppingcart/models/Hive/Item_Model.dart';

import '../../views/pages/Home/HomePage.dart';

class ShoppingListController extends GetxController {
  RxList<ItemModel> shoppingList = <ItemModel>[].obs;
  RxList<ItemModel> selectedItems = <ItemModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isEmpty = true.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String selectedUnit = 'Piece';
  String category = 'Uncategorized';
  int total = 0;
  bool placeIntoCart = false;
  File? selectedImage;

  late Box<ItemModel> shoppingListBox;
  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    noteController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  void clear() {
    nameController.clear();
    priceController.clear();
    noteController.clear();
    quantityController.clear();
    selectedImage = null;
    selectedUnit = 'Piece';
    category = 'Uncategorized';
  }

  void loadItems() async {
    isLoading.value = true;
    shoppingList.value = [];
    shoppingListBox = await Hive.openBox<ItemModel>('shoppingBox');
    shoppingList.addAll(shoppingListBox.values);
    print("SHOPPING${shoppingListBox.values.map((e) => e)}");
    await getTotal().then((value) {
      isLoading.value = false;
    });
    update();
  }

  void addItem({
    String? name,
    String? price,
    String? note,
    String? category,
    String? quantity,
    String? unit,
    bool? placeIntoCart,
    String? imagePath,
  }) async {
    final newItem = ItemModel(
      name: name ?? "",
      price: price ?? "0",
      note: note ?? "",
      category: category ?? "Uncategorized",
      quantity: quantity ?? "1",
      unit: unit ?? "Piece",
      placeIntoCart: placeIntoCart ?? true,
      imagePath: imagePath ?? "",
    );
    shoppingListBox = await Hive.openBox<ItemModel>('shoppingBox');
    await shoppingListBox.add(newItem);
    shoppingList.add(newItem);
    await getTotal();
    selectedItems.refresh();
    Get.to(() => const HomePage());
    update();
  }

  void deleteItem(ItemModel item) async {
    await shoppingListBox.delete(item.key);
    shoppingList.remove(item);
    selectedItems.remove(item);
    await getTotal();
    update();
  }

  Future<void> getTotal() async {
    shoppingListBox = await Hive.openBox<ItemModel>('shoppingBox');
    print("shoppingListBox ${shoppingListBox.values.map((e) => e).toList()}");
    final prices = shoppingListBox.values
        .map((item) => int.tryParse(item.price ?? "0") ?? 0)
        .toList();
    total = prices.isNotEmpty ? prices.reduce((a, b) => a + b) : 0;
    update();
  }
}
