import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ListeSalonsScreen extends StatefulWidget {
  const ListeSalonsScreen({super.key});
  @override
  State<ListeSalonsScreen> createState() => _ListeSalonsScreenState();
}

class _ListeSalonsScreenState extends State<ListeSalonsScreen> {
  List<dynamic> _salons = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerSalons();
  }

  Future<void> _chargerSalons() async {
    final data = await ApiService.get('/salons');
    setState(() { _salons = data; _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nos salons')),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _salons.length,
              itemBuilder: (context, i) {
                final salon = _salons[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(backgroundColor: Color(0xFF7B2238), child: Icon(Icons.store, color: Color(0xFFF5C97A))),
                    title: Text(salon['nom'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(salon['adresse']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/salon/soin', extra: salon['id']),
                  ),
                );
              },
            ),
    );
  }
}