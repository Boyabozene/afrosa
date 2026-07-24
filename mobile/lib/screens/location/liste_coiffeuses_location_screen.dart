import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ListeCoiffeusesLocationScreen extends StatefulWidget {
  const ListeCoiffeusesLocationScreen({super.key});
  @override
  State<ListeCoiffeusesLocationScreen> createState() => _ListeCoiffeusesLocationScreenState();
}

class _ListeCoiffeusesLocationScreenState extends State<ListeCoiffeusesLocationScreen> {
  List<dynamic> _coiffeuses = [];
  bool _chargement = true;

  @override
  void initState() { super.initState(); _chargerCoiffeuses(); }

  Future<void> _chargerCoiffeuses() async {
    final data = await ApiService.get('/coiffeuses/location');
    setState(() { _coiffeuses = data; _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Louer une coiffeuse')),
      body: _chargement ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _coiffeuses.length,
              itemBuilder: (context, i) {
                final c = _coiffeuses[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(backgroundColor: Color(0xFF7B2238), child: Icon(Icons.star, color: Color(0xFFF5C97A))),
                    title: Text('${c['prenom']} ${c['nom']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${c['tarif_journee']}\$/jour • ${c['salon_nom']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/location/formulaire', extra: c),
                  ),
                );
              },
            ),
    );
  }
}