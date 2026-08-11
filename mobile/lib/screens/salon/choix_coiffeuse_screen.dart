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
  int _nbPersonnes = 1;

  @override
  void initState() {
    super.initState();
    _chargerCoiffeuses();
  }

  Future<void> _chargerCoiffeuses() async {
    final data = await ApiService.get('/salons/${widget.extra['salonId']}/coiffeuses');
    setState(() { _coiffeuses = data; _chargement = false; });
  }

  String _initiales(String prenom, String nom) {
    return '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'.toUpperCase();
  }

  int _remisePourcentage(int nb) {
    if (nb >= 4) return 20;
    if (nb == 3) return 15;
    if (nb == 2) return 10;
    return 0;
  }

  void _continuer(String coiffeuseId, String coiffeuseNom) {
    context.push('/salon/creneau', extra: {
      ...widget.extra,
      'coiffeuseId': coiffeuseId,
      'coiffeuseNom': coiffeuseNom,
      'nbPersonnes': _nbPersonnes,
    });
  }

  @override
  Widget build(BuildContext context) {
    final remise = _remisePourcentage(_nbPersonnes);
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
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                      child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Choisir une coiffeuse', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                        Text('Soin : ${widget.extra['soinNom']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E5E5))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nombre de personnes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                          if (remise > 0) ...[
                            const SizedBox(height: 2),
                            Text('-$remise% de remise', style: const TextStyle(fontSize: 12, color: Color(0xFF7B2238), fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _nbPersonnes = _nbPersonnes > 1 ? _nbPersonnes - 1 : 1),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.remove, size: 16, color: Color(0xFF1C1C1C)),
                      ),
                    ),
                    SizedBox(width: 32, child: Text('$_nbPersonnes', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C)))),
                    GestureDetector(
                      onTap: () => setState(() => _nbPersonnes = _nbPersonnes < 10 ? _nbPersonnes + 1 : 10),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : _coiffeuses.isEmpty
                      ? const Center(child: Text('Aucune coiffeuse disponible', style: TextStyle(color: Color(0xFF6B6B6B))))
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          children: [
                            GestureDetector(
                              onTap: () => _continuer(_coiffeuses.first['id'], 'Coiffeuse assignée par le salon'),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F5F0),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF1C1C1C).withValues(alpha: 0.15), style: BorderStyle.solid),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52, height: 52,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0xFFE5E5E5))),
                                      child: const Icon(Icons.shuffle, color: Color(0xFF7B2238), size: 22),
                                    ),
                                    const SizedBox(width: 14),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Peu importe la coiffeuse', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                                          SizedBox(height: 2),
                                          Text('Le salon assigne une coiffeuse disponible', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF6B6B6B)),
                                  ],
                                ),
                              ),
                            ),
                            ..._coiffeuses.map((c) => GestureDetector(
                              onTap: () => _continuer(c['id'], '${c['prenom']} ${c['nom']}'),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE5E5E5)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52, height: 52,
                                      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(26)),
                                      child: Center(
                                        child: Text(_initiales(c['prenom'] ?? '', c['nom'] ?? ''),
                                          style: const TextStyle(color: Color(0xFFF5C97A), fontWeight: FontWeight.w700, fontSize: 16)),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${c['prenom']} ${c['nom']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                                          const SizedBox(height: 4),
                                          Text(c['bio'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF6B6B6B)),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}