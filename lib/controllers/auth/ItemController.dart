import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shoppingcart/models/AddModel.dart';

import '../../models/Hive/Item_Model.dart';

class ItemController extends GetxController {
  var searchQuery = ''.obs;
  var items = <ItemModel>[].obs;
  var filteredItems = <ItemModel>[].obs;
  late Box<ItemModel> shoppingListBox;
  var data = <AddItemModel>[].obs;
  bool isAdded = false;

  bool isLoading = false;

  @override
  void onInit() async {
    super.onInit();
    shoppingListBox = await Hive.openBox<ItemModel>('shoppingBox');
    loadItems();
    searchQuery.listen((query) => filterItems());
  }

  void loadItems() async {
    add();

    filteredItems.assignAll(items);
  }

  void add() {
    data.addAll([
      AddItemModel(
          image: "assets/images/aftershave.jpg", category: "AfterShave"),
      AddItemModel(
          image: "assets/images/airpurifier.jpg", category: "AirPurifier"),
      AddItemModel(image: "assets/images/apple.jpg", category: "Apple"),
    ]);
  }

  addItemInTheList(AddItemModel? addedItem) async {
    var addValue = ItemModel(
        category: addedItem?.category ?? "", image: addedItem?.image ?? "");
    print(addValue);

    shoppingListBox.add(addValue);
    print("${shoppingListBox.values.map(
      (e) {
        e;
      },
    )} Items");
  }

  void filterItems() async {
    if (searchQuery.value.isEmpty) {
      filteredItems.assignAll(items);
    } else {
      filteredItems.assignAll(
        items.where((item) =>
            item.name!.toLowerCase().contains(searchQuery.value.toLowerCase())),
      );
    }
  }

  // void toggleItemAdded(ItemModel item) async {
  //   shoppingListBox = await Hive.openBox<ItemModel>('shoppingBox');
  //   item.isAdded = !item.isAdded;
  //   await item.save();
  //   items.refresh();
  // }

  Future<void> deleteItem(ItemModel item) async {
    await item.delete();
    items.remove(item);
    items.refresh();
    filterItems();
  }
}
