import 'dart:io';

import 'package:bagus_project/core/widget/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class AddProductPage extends StatefulWidget {
  final VoidCallback onProductAdded;

  const AddProductPage({super.key, required this.onProductAdded});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  File? selectedImage;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    final price = double.tryParse(priceController.text.trim());

    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        price == null) {
      AppSnackbar.error(context, 'Please fill all fields correctly');
      return;
    }

    final success = await context.read<ProductProvider>().addProduct(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      price: price,
      imagePath: selectedImage?.path,
    );

    if (!mounted) return;

    if (success) {
      titleController.clear();
      descriptionController.clear();
      priceController.clear();

      AppSnackbar.success(context, 'Product added successfully');

      widget.onProductAdded();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProductProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Product Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 48),
                          SizedBox(height: 8),
                          Text('Tap to pick image'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _addProduct,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
