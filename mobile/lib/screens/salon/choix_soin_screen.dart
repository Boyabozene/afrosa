import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ChoixSoinScreen extends StatefulWidget {
  final String salonId;
  const ChoixSoinScreen({super.key, required this.salonId});
  @override
  State<ChoixSoinScreen> createState() => _ChoixSoinScreenState();
}

class _ChoixSoinScreenState extends State<ChoixSoinScreen> {
  List<dynamic> _soins = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerSoins();
  }

  Future<void> _chargerSoins() async {
    final data = await ApiService.get('/soins');
    setState(() { _soins = data; _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir un soin')),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
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
                    subtitle: Text('${soin['duree_minutes']} min • ${soin['prix_salon']}\$'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/salon/coiffeuse', extra: {
                      'salonId': widget.salonId,
                      'soinId': soin['id'],
                      'soinNom': soin['nom'],
                      'montant': soin['prix_salon'],
                    }),
                  ),
                );
              },
            ),
    );
  }
}