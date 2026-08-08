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
                        const Text('Choisir une coiffeuse', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                        Text('Soin : ${widget.extra['soinNom']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
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
                              onTap: () => context.push('/salon/creneau', extra: {
                                ...widget.extra,
                                'coiffeuseId': c['id'],
                                'coiffeuseNom': '${c['prenom']} ${c['nom']}',
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
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1C1C1C),
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _initiales(c['prenom'] ?? '', c['nom'] ?? ''),
                                          style: const TextStyle(color: Color(0xFFF5C97A), fontWeight: FontWeight.w700, fontSize: 16),
                                        ),
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
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              if (c['disponible_domicile'] == true) ...[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(999)),
                                                  child: const Text('Domicile', style: TextStyle(fontSize: 10, color: Color(0xFF7B2238), fontWeight: FontWeight.w600)),
                                                ),
                                                const SizedBox(width: 6),
                                              ],
                                              if (c['disponible_location'] == true)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(999)),
                                                  child: const Text('Événement', style: TextStyle(fontSize: 10, color: Color(0xFF7B2238), fontWeight: FontWeight.w600)),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF6B6B6B)),
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