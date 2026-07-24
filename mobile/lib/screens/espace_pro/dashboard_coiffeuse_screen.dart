import 'package:flutter/material.dart';

class DashboardCoiffeuseScreen extends StatelessWidget {
  const DashboardCoiffeuseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Espace coiffeuse')),
      body: const Center(child: Text('Dashboard coiffeuse')),
    );
  }
}