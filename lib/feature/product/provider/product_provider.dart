import 'dart:async';

import 'package:flutter/material.dart';

import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository productRepository;

  ProductProvider({required this.productRepository});

  List<ProductModel> products = [];
  bool isLoading = false;
  String? errorMessage;
  String? imagePath;
  final searchController = TextEditingController();

  Timer? debounce;

  void initializeProducts() {
    if (products.isEmpty) {
      getProducts();
    }
  }

  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }

    debounce = Timer(const Duration(milliseconds: 500), () {
      getProducts(query: value.trim());
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  Future<void> getProducts({String? query}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      products = await productRepository.getProducts(query: query);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct({
    required int id,
    required String title,
    required String description,
    required double price,
    String? imagePath,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final index = products.indexWhere((product) => product.id == id);

      if (index == -1) {
        errorMessage = 'Product not found';
        return false;
      }

      final oldProduct = products[index];

      // DummyJSON product hasil add biasanya tidak benar-benar tersimpan di server.
      // Jadi untuk id > 100, update lokal saja.
      if (id > 100) {
        products[index] = ProductModel(
          id: oldProduct.id,
          title: title,
          description: description,
          price: price,
          thumbnail: oldProduct.thumbnail,
          imagePath: imagePath ?? oldProduct.imagePath,
        );

        return true;
      }

      final updatedProduct = await productRepository.updateProduct(
        id: id,
        title: title,
        description: description,
        price: price,
      );

      products[index] = ProductModel(
        id: updatedProduct.id,
        title: updatedProduct.title,
        description: updatedProduct.description,
        price: updatedProduct.price,
        thumbnail: oldProduct.thumbnail,
        imagePath: imagePath ?? oldProduct.imagePath,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await productRepository.deleteProduct(id);
      products.removeWhere((product) => product.id == id);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct({
    required String title,
    required String description,
    required double price,
    String? imagePath,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final newProduct = await productRepository.addProduct(
        title: title,
        description: description,
        price: price,
      );

      final localProduct = ProductModel(
        id: newProduct.id,
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        thumbnail: newProduct.thumbnail,
        imagePath: imagePath,
      );

      products = [localProduct, ...products];

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
