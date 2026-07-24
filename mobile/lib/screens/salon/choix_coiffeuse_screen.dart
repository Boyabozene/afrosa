import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ChoixCoiffeuseScreen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const ChoixCoiffeuseScreen({super.key, required this.extra});
  @override
  State<ChoixCoiffeuseScreen> createState() => _ChoixCoiffeuseScreenState();
}

class _ChoixCoiffeuseScreenState extends State<ChoixCoiffeuseScreen> {
  List<dynamic> _coiffeuses = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerCoiffeuses();
  }

  Future<void> _chargerCoiffeuses() async {
    final data = await ApiService.get('/salons/${widget.extra['salonId']}/coiffeuses');
    setState(() { _coiffeuses = data; _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une coiffeuse')),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
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
                    leading: const CircleAvatar(backgroundColor: Color(0xFFC4622D), child: Icon(Icons.person, color: Colors.white)),
                    title: Text('${c['prenom']} ${c['nom']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(c['bio'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/salon/creneau', extra: {
                      ...widget.extra,
                      'coiffeuseId': c['id'],
                      'coiffeuseNom': '${c['prenom']} ${c['nom']}',
                    }),
                  ),
                );
              },
            ),
    );
  }
}