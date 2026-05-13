import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../product/presentation/product_page.dart';
import '../../product/presentation/add_product_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../provider/navigation_provider.dart';
import 'coming_soon_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Widget> _pages(BuildContext context) {
    return [
      const ProductPage(),
      const ComingSoonPage(title: 'Menu 2'),
      AddProductPage(
        onProductAdded: () {
          context.read<NavigationProvider>().goToProductPage();
        },
      ),
      const ComingSoonPage(title: 'Menu 4'),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();

    return Scaffold(
      body: _pages(context)[navigationProvider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: navigationProvider.changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Product',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Menu 2'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_outlined),
            label: 'Menu 4',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
