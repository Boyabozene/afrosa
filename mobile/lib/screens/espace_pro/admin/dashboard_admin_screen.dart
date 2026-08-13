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

  void _confirmerDeconnexion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Se déconnecter ?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text('Vous devrez vous reconnecter pour accéder au tableau de bord.', style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler', style: TextStyle(color: Color(0xFF6B6B6B)))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.deconnexion();
              if (context.mounted) context.go('/connexion');
            },
            child: const Text('Déconnexion', style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      body: SafeArea(
        child: _chargement
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
            : RefreshIndicator(
                color: const Color(0xFF1C1C1C),
                onRefresh: _charger,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Administration', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C))),
                              Text('Afrosa • Kinshasa', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                            ],
                          ),
                          GestureDetector(
                            onTap: _confirmerDeconnexion,
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                              child: const Icon(Icons.logout, size: 18, color: Color(0xFFCC0000)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('VUE D\'ENSEMBLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9B9B9B), letterSpacing: 0.5)),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _statCard('Salons', _stats['salons']?.toString() ?? '0', Icons.store_outlined),
                          _statCard('Coiffeuses', _stats['coiffeuses']?.toString() ?? '0', Icons.people_outline),
                          _statCard('RDV salon', _stats['reservations_salon']?.toString() ?? '0', Icons.calendar_today_outlined),
                          _statCard('RDV domicile', _stats['reservations_domicile']?.toString() ?? '0', Icons.home_outlined),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _statCardLarge('Locations pour événements', _stats['locations']?.toString() ?? '0', Icons.auto_awesome_outlined),
                      const SizedBox(height: 28),
                      const Text('DERNIÈRES RÉSERVATIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9B9B9B), letterSpacing: 0.5)),
                      const SizedBox(height: 12),
                      if (_reservations.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E5E5))),
                          child: const Column(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 40, color: Color(0xFFE5E5E5)),
                              SizedBox(height: 8),
                              Text('Aucune réservation pour le moment', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 13)),
                            ],
                          ),
                        )
                      else
                        ..._reservations.map((r) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E5E5))),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.person_outline, size: 18, color: Color(0xFF7B2238)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${r['cliente_prenom']} ${r['cliente_nom']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1C1C1C))),
                                    const SizedBox(height: 2),
                                    Text('${r['soin_nom']} • ${r['coiffeuse_prenom']} ${r['coiffeuse_nom']}', style: const TextStyle(fontSize: 11, color: Color(0xFF6B6B6B))),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${r['montant']} ${r['devise']}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C), fontSize: 13)),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: r['statut'] == 'confirmee' ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(r['statut'] == 'confirmee' ? 'Confirmé' : r['statut'],
                                      style: TextStyle(fontSize: 10, color: r['statut'] == 'confirmee' ? Colors.green : const Color(0xFF9B9B9B))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _statCard(String titre, String valeur, IconData icone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E5E5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: const Color(0xFF7B2238), size: 22),
          const Spacer(),
          Text(valeur, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C))),
          Text(titre, style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
        ],
      ),
    );
  }

  Widget _statCardLarge(String titre, String valeur, IconData icone) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFFF5C97A).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icone, color: const Color(0xFFF5C97A), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(titre, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Text(valeur, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFF5C97A))),
        ],
      ),
    );
  }
}