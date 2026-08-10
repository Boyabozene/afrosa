import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdresseScreen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const AdresseScreen({super.key, required this.extra});
  @override
  State<AdresseScreen> createState() => _AdresseScreenState();
}

class _AdresseScreenState extends State<AdresseScreen> {
  final _adresseController = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String _heure = '09:00';

  final List<String> _heures = ['08:00', '09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
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
                  const Text('Votre adresse', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Adresse complète', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              TextField(
                controller: _adresseController,
                maxLines: 3,
		onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Quartier, avenue, référence...',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Date du rendez-vous', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 14,
                  itemBuilder: (context, i) {
                    final d = DateTime.now().add(Duration(days: i + 1));
                    final selectionne = d.day == _date.day && d.month == _date.month;
                    return GestureDetector(
                      onTap: () => setState(() => _date = d),
                      child: Container(
                        width: 56,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: selectionne ? const Color(0xFF1C1C1C) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selectionne ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'][d.weekday % 7],
                              style: TextStyle(fontSize: 11, color: selectionne ? Colors.white70 : const Color(0xFF6B6B6B))),
                            const SizedBox(height: 4),
                            Text('${d.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: selectionne ? Colors.white : const Color(0xFF1C1C1C))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text('Heure souhaitée', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10, runSpacing: 10,
                children: _heures.map((h) {
                  final selectionne = h == _heure;
                  return GestureDetector(
                    onTap: () => setState(() => _heure = h),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectionne ? const Color(0xFF1C1C1C) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: selectionne ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                      ),
                      child: Text(h, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selectionne ? Colors.white : const Color(0xFF1C1C1C))),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _adresseController.text.trim().isEmpty ? null : () => context.push('/paiement', extra: {
                  ...widget.extra,
                  'adresse': _adresseController.text.trim(),
                  'dateHeure': '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}T$_heure:00',
                  'type': 'domicile',
                }),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _adresseController.text.trim().isEmpty ? const Color(0xFF6B6B6B) : const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continuer vers le paiement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}