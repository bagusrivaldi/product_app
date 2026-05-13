import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  final String title;

  const ComingSoonPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: const Center(
        child: Text('Coming Soon', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
