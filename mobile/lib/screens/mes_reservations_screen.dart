import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({super.key});
  @override
  State<MesReservationsScreen> createState() => _MesReservationsScreenState();
}

class _MesReservationsScreenState extends State<MesReservationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _salon = [], _domicile = [], _location = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _charger();
  }

  Future<void> _charger() async {
    final s = await ApiService.get('/reservations/salon/mes-reservations', auth: true);
    final d = await ApiService.get('/reservations/domicile/mes-reservations', auth: true);
    final l = await ApiService.get('/locations/mes-locations', auth: true);
    setState(() { _salon = s is List ? s : []; _domicile = d is List ? d : []; _location = l is List ? l : []; _chargement = false; });
  }

  Widget _tuile(Map<String, dynamic> r, String type) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(r['soin_nom'] ?? r['type_evenement'] ?? 'Réservation', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${r['coiffeuse_prenom'] ?? ''} ${r['coiffeuse_nom'] ?? ''} • ${r['statut']}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: r['statut'] == 'confirmee' ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(r['statut_paiement'] == 'paye_demo' ? 'Payé' : 'En attente',
            style: TextStyle(fontSize: 11, color: r['statut_paiement'] == 'paye_demo' ? Colors.green : Colors.orange)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFF5C97A),
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: 'Salon'), Tab(text: 'Domicile'), Tab(text: 'Location')],
        ),
      ),
      body: _chargement ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                ListView(padding: const EdgeInsets.all(16), children: _salon.map((r) => _tuile(r, 'salon')).toList()),
                ListView(padding: const EdgeInsets.all(16), children: _domicile.map((r) => _tuile(r, 'domicile')).toList()),
                ListView(padding: const EdgeInsets.all(16), children: _location.map((r) => _tuile(r, 'location')).toList()),
              ],
            ),
    );
  }
}