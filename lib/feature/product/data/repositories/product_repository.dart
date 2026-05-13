import '../../../../core/api/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient apiClient;

  ProductRepository({required this.apiClient});

  Future<List<ProductModel>> getProducts({String? query}) async {
    final endpoint = query != null && query.isNotEmpty
        ? '/products/search?q=$query'
        : '/products';

    final response = await apiClient.dio.get(endpoint);

    final List products = response.data['products'];

    return products.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> updateProduct({
    required int id,
    required String title,
    required String description,
    required double price,
  }) async {
    final response = await apiClient.dio.put(
      '/products/$id',
      data: {'title': title, 'description': description, 'price': price},
    );

    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await apiClient.dio.delete('/products/$id');
  }

  Future<ProductModel> addProduct({
    required String title,
    required String description,
    required double price,
  }) async {
    final response = await apiClient.dio.post(
      '/products/add',
      data: {'title': title, 'description': description, 'price': price},
    );

    return ProductModel.fromJson(response.data);
  }
}
