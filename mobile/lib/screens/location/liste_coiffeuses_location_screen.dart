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
  void initState() {
    super.initState();
    _chargerCoiffeuses();
  }

  Future<void> _chargerCoiffeuses() async {
    final data = await ApiService.get('/coiffeuses/location');
    setState(() { _coiffeuses = data; _chargement = false; });
  }

  String _initiales(String prenom, String nom) {
    return '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'.toUpperCase();
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
                        const Text('Louer une coiffeuse', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                        const Text('Pour vos événements spéciaux', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : _coiffeuses.isEmpty
                      ? const Center(child: Text('Aucune coiffeuse disponible', style: TextStyle(color: Color(0xFF6B6B6B))))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _coiffeuses.length,
                          itemBuilder: (context, i) {
                            final c = _coiffeuses[i];
                            return GestureDetector(
                              onTap: () => context.push('/location/formulaire', extra: c),
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
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Text(_initiales(c['prenom'] ?? '', c['nom'] ?? ''),
                                              style: const TextStyle(color: Color(0xFFF5C97A), fontWeight: FontWeight.w700, fontSize: 16)),
                                          ),
                                          Positioned(
                                            bottom: 0, right: 0,
                                            child: Container(
                                              width: 16, height: 16,
                                              decoration: const BoxDecoration(color: Color(0xFF7B2238), shape: BoxShape.circle),
                                              child: const Icon(Icons.star, size: 10, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${c['prenom']} ${c['nom']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                                          const SizedBox(height: 4),
                                          Row(children: [
                                            const Icon(Icons.store_outlined, size: 12, color: Color(0xFF9B9B9B)),
                                            const SizedBox(width: 4),
                                            Text(c['salon_nom'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF9B9B9B))),
                                          ]),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('${c['tarif_journee']}\$', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                                        const Text('par jour', style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B))),
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