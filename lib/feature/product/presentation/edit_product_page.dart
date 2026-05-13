import 'package:bagus_project/core/widget/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/product_model.dart';
import '../provider/product_provider.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.product.title);
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    final price = double.tryParse(priceController.text.trim());

    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        price == null) {
      AppSnackbar.error(context, 'Please fill all fields correctly');

      return;
    }

    final success = await context.read<ProductProvider>().updateProduct(
      id: widget.product.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      price: price,
    );

    if (!mounted) return;

    if (success) {
      AppSnackbar.success(context, 'Product updated successfully');

      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProductProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateProduct,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
