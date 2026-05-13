import 'package:bagus_project/feature/auth/data/repository/auth_repository.dart';
import 'package:bagus_project/feature/auth/provider/auth_provider.dart';
import 'package:bagus_project/feature/home/provider/navigation_provider.dart';
import 'package:bagus_project/feature/product/data/repositories/product_repository.dart';
import 'package:bagus_project/feature/product/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'api_client.dart';
import '../storage/local_storage.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    Provider<ApiClient>(create: (_) => ApiClient()),
    Provider<LocalStorage>(create: (_) => LocalStorage()),
    ProxyProvider2<ApiClient, LocalStorage, AuthRepository>(
      update: (_, apiClient, localStorage, __) {
        return AuthRepository(apiClient: apiClient, localStorage: localStorage);
      },
    ),
    ChangeNotifierProxyProvider2<AuthRepository, LocalStorage, AuthProvider>(
      create: (context) => AuthProvider(
        authRepository: context.read<AuthRepository>(),
        localStorage: context.read<LocalStorage>(),
      ),
      update: (_, authRepository, localStorage, previous) {
        return previous ??
            AuthProvider(
              authRepository: authRepository,
              localStorage: localStorage,
            );
      },
    ),
    ProxyProvider<ApiClient, ProductRepository>(
      update: (_, apiClient, __) {
        return ProductRepository(apiClient: apiClient);
      },
    ),
    ChangeNotifierProxyProvider<ProductRepository, ProductProvider>(
      create: (context) =>
          ProductProvider(productRepository: context.read<ProductRepository>()),
      update: (_, productRepository, previous) {
        return previous ??
            ProductProvider(productRepository: productRepository);
      },
    ),
    ChangeNotifierProvider<NavigationProvider>(
      create: (_) => NavigationProvider(),
    ),
  ];
}
