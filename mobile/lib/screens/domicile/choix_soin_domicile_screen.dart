import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ChoixSoinDomicileScreen extends StatefulWidget {
  const ChoixSoinDomicileScreen({super.key});
  @override
  State<ChoixSoinDomicileScreen> createState() => _ChoixSoinDomicileScreenState();
}

class _ChoixSoinDomicileScreenState extends State<ChoixSoinDomicileScreen> {
  List<dynamic> _soins = [];
  bool _chargement = true;

  @override
  void initState() { super.initState(); _chargerSoins(); }

  Future<void> _chargerSoins() async {
    final data = await ApiService.get('/soins');
    setState(() { _soins = data; _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soin à domicile')),
      body: _chargement ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _soins.length,
              itemBuilder: (context, i) {
                final soin = _soins[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(soin['nom'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${soin['duree_minutes']} min • ${soin['prix_domicile']}\$'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/domicile/coiffeuse', extra: soin['id']),
                  ),
                );
              },
            ),
    );
  }
}