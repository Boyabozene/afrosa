import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ChoixCoiffeusesDomicileScreen extends StatefulWidget {
  final String soinId;
  const ChoixCoiffeusesDomicileScreen({super.key, required this.soinId});
  @override
  State<ChoixCoiffeusesDomicileScreen> createState() => _ChoixCoiffeusesDomicileScreenState();
}

class _ChoixCoiffeusesDomicileScreenState extends State<ChoixCoiffeusesDomicileScreen> {
  List<dynamic> _coiffeuses = [];
  bool _chargement = true;

  @override
  void initState() { super.initState(); _chargerCoiffeuses(); }

  Future<void> _chargerCoiffeuses() async {
    final data = await ApiService.get('/coiffeuses/domicile');
    setState(() { _coiffeuses = data; _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une coiffeuse')),
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
                    leading: const CircleAvatar(backgroundColor: Color(0xFFC4622D), child: Icon(Icons.person, color: Colors.white)),
                    title: Text('${c['prenom']} ${c['nom']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(c['bio'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/domicile/adresse', extra: {
                      'coiffeuseId': c['id'],
                      'coiffeuseNom': '${c['prenom']} ${c['nom']}',
                      'soinId': widget.soinId,
                    }),
                  ),
                );
              },
            ),
    );
  }
}