import 'package:bagus_project/core/widget/app_empty.dart';
import 'package:bagus_project/core/widget/app_error.dart';
import 'package:bagus_project/core/widget/app_scaffold.dart';
import 'package:bagus_project/core/widget/product_card.dart';
import 'package:bagus_project/core/widget/product_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../provider/product_provider.dart';
import 'product_detail_page.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final productProvider = context.watch<ProductProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.initializeProducts();
    });

    return AppScaffold(
      title: 'Product',
      showBackButton: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user == null
                        ? 'Welcome User'
                        : 'Welcome ${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover your favorite products',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: productProvider.searchController,
              onChanged: productProvider.onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Builder(
              builder: (_) {
                if (productProvider.isLoading &&
                    productProvider.products.isEmpty) {
                  return const ProductSkeleton();
                }

                if (productProvider.errorMessage != null) {
                  return AppError(
                    message: productProvider.errorMessage!,
                    onRetry: () {
                      productProvider.getProducts(
                        query: productProvider.searchController.text.trim(),
                      );
                    },
                  );
                }

                if (productProvider.products.isEmpty) {
                  return const AppEmpty(
                    title: 'Product Not Found',
                    message: 'Try searching with another keyword.',
                    icon: Icons.search_off,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await productProvider.getProducts(
                      query: productProvider.searchController.text.trim(),
                    );
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
