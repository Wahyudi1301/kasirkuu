import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Order')),
      body: const Center(
        child: Text('Halaman History Order', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}