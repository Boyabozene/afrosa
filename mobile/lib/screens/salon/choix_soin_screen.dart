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
  String? _gammeSelectionnee;
  List<String> _gammes = [];

  @override
  void initState() {
    super.initState();
    _chargerSoins();
  }

  Future<void> _chargerSoins() async {
    final data = await ApiService.get('/soins');
    final gammes = <String>{};
    for (final s in data) { gammes.add(s['gamme_nom']); }
    setState(() {
      _soins = data;
      _gammes = gammes.toList();
      _gammeSelectionnee = _gammes.isNotEmpty ? _gammes.first : null;
      _chargement = false;
    });
  }

  List<dynamic> get _soinsFiltres => _gammeSelectionnee == null
      ? _soins
      : _soins.where((s) => s['gamme_nom'] == _gammeSelectionnee).toList();

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
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                      child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF1C1C1C)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Choisir un soin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                ],
              ),
            ),
            if (_gammes.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _gammes.length,
                  itemBuilder: (context, i) {
                    final actif = _gammes[i] == _gammeSelectionnee;
                    return GestureDetector(
                      onTap: () => setState(() => _gammeSelectionnee = _gammes[i]),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: actif ? const Color(0xFF1C1C1C) : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: actif ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                        ),
                        child: Text(_gammes[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: actif ? Colors.white : const Color(0xFF6B6B6B))),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _soinsFiltres.length,
                      itemBuilder: (context, i) {
                        final soin = _soinsFiltres[i];
                        return GestureDetector(
                          onTap: () => context.push('/salon/coiffeuse', extra: {
                            'salonId': widget.salonId,
                            'soinId': soin['id'],
                            'soinNom': soin['nom'],
                            'montant': soin['prix_salon'],
                            'devise': 'USD',
                          }),
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
                                  decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(12)),
                                  child: const Center(child: Icon(Icons.spa_outlined, color: Color(0xFF7B2238), size: 24)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(soin['nom'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                                      const SizedBox(height: 4),
                                      Text('${soin['duree_minutes']} min', style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${soin['prix_salon']}\$', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                                    Text('${soin['prix_salon_cdf']} CDF', style: const TextStyle(fontSize: 11, color: Color(0xFF6B6B6B))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}