import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ListeSalonsScreen extends StatefulWidget {
  const ListeSalonsScreen({super.key});
  @override
  State<ListeSalonsScreen> createState() => _ListeSalonsScreenState();
}

class _ListeSalonsScreenState extends State<ListeSalonsScreen> {
  List<dynamic> _salons = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerSalons();
  }

  Future<void> _chargerSalons() async {
    final data = await ApiService.get('/salons');
    setState(() { _salons = data; _chargement = false; });
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
                  const Text('Nos salons', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1C1C1C).withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF7B2238)),
                    SizedBox(width: 6),
                    Text('Kinshasa, RDC', style: TextStyle(fontSize: 12, color: Color(0xFF1C1C1C))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _salons.length,
                      itemBuilder: (context, i) {
                        final salon = _salons[i];
                        return GestureDetector(
                          onTap: () => context.push('/salon/soin', extra: salon['id']),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5E5E5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1C),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.store, color: Color(0xFFF5C97A), size: 36),
                                        const SizedBox(height: 8),
                                        Text(salon['nom'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF7B2238)),
                                          const SizedBox(width: 4),
                                          Expanded(child: Text(salon['adresse'], style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)))),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF7B2238)),
                                          const SizedBox(width: 4),
                                          Text(salon['telephone'] ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B6B))),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1C1C1C),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Réserver ici', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                            SizedBox(width: 6),
                                            Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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