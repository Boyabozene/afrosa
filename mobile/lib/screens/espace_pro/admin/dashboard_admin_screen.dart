import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});
  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  Map<String, dynamic> _stats = {};
  List<dynamic> _reservations = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final stats = await ApiService.get('/admin/stats', auth: true);
    final reservations = await ApiService.get('/admin/reservations', auth: true);
    setState(() {
      _stats = stats is Map<String, dynamic> ? stats : {};
      _reservations = reservations is List ? reservations : [];
      _chargement = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration Afrosa'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.deconnexion();
              if (context.mounted) context.go('/connexion');
            },
          ),
        ],
      ),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vue d\'ensemble', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _statCard('Salons', _stats['salons']?.toString() ?? '0', Icons.store),
                      _statCard('Coiffeuses', _stats['coiffeuses']?.toString() ?? '0', Icons.person),
                      _statCard('RDV salon', _stats['reservations_salon']?.toString() ?? '0', Icons.calendar_today),
                      _statCard('RDV domicile', _stats['reservations_domicile']?.toString() ?? '0', Icons.home),
                      _statCard('Locations', _stats['locations']?.toString() ?? '0', Icons.star),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Dernières réservations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
                  const SizedBox(height: 12),
                  if (_reservations.isEmpty)
                    const Center(child: Text('Aucune réservation pour le moment', style: TextStyle(color: Colors.grey)))
                  else
                    ..._reservations.map((r) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text('${r['cliente_prenom']} ${r['cliente_nom']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('${r['soin_nom']} • ${r['coiffeuse_prenom']} ${r['coiffeuse_nom']}', style: const TextStyle(fontSize: 12)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${r['montant']} ${r['devise']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B2238), fontSize: 13)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: r['statut'] == 'confirmee' ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(r['statut'], style: TextStyle(fontSize: 10, color: r['statut'] == 'confirmee' ? Colors.green : Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    )),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String titre, String valeur, IconData icone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, color: const Color(0xFF7B2238), size: 24),
          const SizedBox(height: 8),
          Text(valeur, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
          Text(titre, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}