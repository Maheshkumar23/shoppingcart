import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppingcart/constants/colors.dart';
import 'package:shoppingcart/constants/style.dart';
import 'package:shoppingcart/controllers/auth/ItemController.dart';

class SearchFilter extends StatefulWidget {
  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final ItemController controller = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.greenColor,
        iconTheme: IconThemeData(color: MyColors.whiteColor),
        title: Text(
          "My List",
          style: MyTextStyle.header,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'What do you want to buy?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: 'All',
                  items: ['All'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  final item = controller.data[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(item.image ?? ""),
                      ),
                      title: Text(
                        item.category ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            controller.addItemInTheList(item);
                          }),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
