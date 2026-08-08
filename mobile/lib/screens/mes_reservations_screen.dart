import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    setState(() {
      _salon = s is List ? s : [];
      _domicile = d is List ? d : [];
      _location = l is List ? l : [];
      _chargement = false;
    });
  }

  Widget _tuile(Map<String, dynamic> r, String type) {
    final paye = r['statut_paiement'] == 'paye_demo';
    final annule = r['statut'] == 'annulee';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  r['soin_nom'] ?? r['type_evenement'] ?? 'Réservation',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: annule ? const Color(0xFFF5F5F5) : paye ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  annule ? 'Annulé' : paye ? 'Payé' : 'En attente',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: annule ? const Color(0xFF9B9B9B) : paye ? Colors.green : Colors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${r['coiffeuse_prenom'] ?? ''} ${r['coiffeuse_nom'] ?? ''}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)),
          ),
          if (r['salon_nom'] != null) ...[
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.store_outlined, size: 12, color: Color(0xFF9B9B9B)),
              const SizedBox(width: 4),
              Text(r['salon_nom'], style: const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B))),
            ]),
          ],
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFE5E5E5), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${r['montant'] ?? r['montant_total'] ?? ''} ${r['devise'] ?? 'USD'}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C)),
              ),
              if (r['date_heure'] != null)
                Text(
                  _formatDate(r['date_heure']),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      final mois = ['jan', 'fév', 'mar', 'avr', 'mai', 'jun', 'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'];
      return '${d.day} ${mois[d.month - 1]} ${d.year} • ${d.hour.toString().padLeft(2,'0')}h${d.minute.toString().padLeft(2,'0')}';
    } catch (_) {
      return dateStr;
    }
  }

  Widget _listeVide() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 48, color: Color(0xFFE5E5E5)),
          SizedBox(height: 12),
          Text('Aucune réservation', style: TextStyle(fontSize: 15, color: Color(0xFF6B6B6B))),
          SizedBox(height: 4),
          Text('Vos réservations apparaîtront ici', style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => StatefulNavigationShell.of(context).goBranch(0),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                      child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Mes réservations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C))),
                  const Spacer(),
                  GestureDetector(
                    onTap: _charger,
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                      child: const Icon(Icons.refresh, size: 18, color: Color(0xFF1C1C1C)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF9B9B9B),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                indicator: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(10)),
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Salon'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Domicile'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Location'))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _salon.isEmpty ? _listeVide() : ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: _salon.map((r) => _tuile(r, 'salon')).toList()),
                        _domicile.isEmpty ? _listeVide() : ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: _domicile.map((r) => _tuile(r, 'domicile')).toList()),
                        _location.isEmpty ? _listeVide() : ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: _location.map((r) => _tuile(r, 'location')).toList()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}