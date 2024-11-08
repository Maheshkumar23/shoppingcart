import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingcart/constants/colors.dart';
import 'package:shoppingcart/controllers/auth/shoppingController.dart';

import '../../../models/Hive/Item_Model.dart';
import '../../../utils/textContain.dart';

class AddItem extends StatefulWidget {
  final ItemModel? item;
  const AddItem({super.key, this.item});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        controller.selectedImage = File(pickedFile.path);
      });
    }
  }

  final ShoppingListController controller = Get.put(ShoppingListController());

  void saveItem() async {
    final String name = controller.nameController.text;

    final String price = controller.priceController.text;

    final String quantity = controller.quantityController.text;

    final String unit = controller.selectedUnit;

    final String category = controller.category;

    final String note = controller.noteController.text;

    final String imagePath = controller.selectedImage?.path ?? "";

    bool placeIntoCart = controller.placeIntoCart;

    controller.addItem(
        name: name,
        price: price,
        quantity: quantity,
        unit: unit,
        category: category,
        note: note,
        imagePath: imagePath,
        placeIntoCart: placeIntoCart);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.item != null) {
      controller.nameController.text = widget.item?.name ?? "";

      controller.priceController.text = widget.item?.price ?? "";

      controller.quantityController.text = widget.item?.quantity ?? "";

      controller.category = widget.item?.category ?? "";

      controller.noteController.text = widget.item?.note ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingListController controller = Get.put(ShoppingListController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.greenColor,
        iconTheme: const IconThemeData(color: MyColors.whiteColor),
        title: const Text(
          TextContain.addItem,
          style: TextStyle(color: MyColors.whiteColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState?.validate() != true) {
                return;
              }
              saveItem();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: const UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.greenColor)),
                    hintText: 'Enter the product name',
                    suffixIcon: const Icon(Icons.mic)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.quantityController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter quantity";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: const UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: MyColors.greenColor))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedUnit,
                      items: ['Piece', 'Kg', 'Litre']
                          .map((unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedUnit = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter quantity";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Unit',
                          border: const UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: MyColors.greenColor))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter price";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Price',
                          border: const UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: MyColors.greenColor))),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(Icons.shopping_bag),
                  Checkbox(
                    value: controller.placeIntoCart,
                    onChanged: (value) {
                      setState(() {
                        controller.placeIntoCart = value!;
                      });
                    },
                  ),
                  const Text('Place into cart')
                ],
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: controller.category,
                items: ['Uncategorized', 'Groceries', 'Electronics', 'Clothing']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    controller.category = value!;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Category',
                    border: const UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.greenColor))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.noteController,
                decoration: InputDecoration(
                    labelText: 'Note',
                    border: const UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.greenColor))),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickImage,
                child: controller.selectedImage != null
                    ? Image.file(
                        controller.selectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.camera_alt),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
