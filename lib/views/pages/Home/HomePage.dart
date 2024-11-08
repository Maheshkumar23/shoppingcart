import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shoppingcart/constants/style.dart';
import 'package:shoppingcart/controllers/auth/ItemController.dart';
import 'package:shoppingcart/controllers/auth/shoppingController.dart';
import 'package:shoppingcart/views/pages/Home/AddItem_view.dart';
import 'package:shoppingcart/views/pages/SearchFilter/searchFilter_view.dart';
import 'package:shoppingcart/views/widgets/drawerWidget.dart';

import '../../../constants/colors.dart';
import '../../../models/Hive/Item_Model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = false;

  late ShoppingListController controller;

  late ItemController itemController;

  void callFunc() {
    isloading = true;
    controller = Get.put(ShoppingListController());

    print("LEN${controller.selectedItems.length}");
    isloading = false;
    setState(() {});
  }

  void itemFunc() {
    isloading = true;
    itemController = Get.put(ItemController());
    print("LEN${itemController.items.length}");
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    controller = Get.put(ShoppingListController());
    controller.shoppingList.value = [];
    controller.loadItems();
    // itemFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShoppingListController>(
        init: controller,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: MyColors.greenColor,
              iconTheme: const IconThemeData(color: MyColors.whiteColor),
              title: const Row(
                children: [
                  Text(
                    'My list',
                    style: MyTextStyle.header,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: MyColors.whiteColor,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.format_list_bulleted_add,
                    color: MyColors.whiteColor,
                  ),
                  onPressed: () async {
                    Get.to(() => SearchFilter())?.then((value) {
                      controller.loadItems();
                      controller.update();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: MyColors.whiteColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            drawer: const DrawerPage(),
            body: controller.isLoading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.shoppingList.isEmpty
                    ? const Center(
                        child: Text(
                          'No items to show.\nTap "+" to add products.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        itemCount: controller.shoppingList.length,
                        itemBuilder: (context, index) {
                          final item = controller.shoppingList[index];
                          return SnippetWidget(
                            item: item,
                            onTap: () {
                              controller.deleteItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Item is deleted",
                                    style: TextStyle(
                                      color: MyColors.whiteColor,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: MyColors.blueColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              onPressed: () async {
                Get.to(() => const AddItem());
              },
              child: const Icon(
                Icons.add,
                color: MyColors.whiteColor,
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: MyColors.lightgreenColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calculate, size: 40),
                        const SizedBox(
                          width: 4,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text('Total (${controller.shoppingList.length})',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('₹ ${controller.total}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_cart, size: 40),
                        const SizedBox(
                          width: 4,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text('Cart (${controller.shoppingList.length})',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('₹ ${controller.total}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class SnippetWidget extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  const SnippetWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColoredBox(
                  color: MyColors.greyColor.withOpacity(0.3),
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: (item.imagePath ?? "").isEmpty
                          ? Image.asset(item.image ?? "")
                          : Image.file(
                              File(
                                item.imagePath ?? "",
                              ),
                              width: 100,
                              height: 100,
                            )),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.greenColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: item.category ?? "",
                                    style: const TextStyle(
                                        color: MyColors.whiteColor))
                              ])),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                onTap();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.delete),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (item.name != null)
                        Text(
                          "Item: ${item.name}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      if ((item.price ?? "").isNotEmpty)
                        Text(
                          "₹${item.price ?? "-"}",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
