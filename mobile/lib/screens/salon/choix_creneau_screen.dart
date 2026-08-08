import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';

class ChoixCreneauScreen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const ChoixCreneauScreen({super.key, required this.extra});
  @override
  State<ChoixCreneauScreen> createState() => _ChoixCreneauScreenState();
}

class _ChoixCreneauScreenState extends State<ChoixCreneauScreen> {
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  List<String> _creneaux = [];
  bool _chargement = false;
  String? _creneauSelectionne;

  Future<void> _chargerCreneaux() async {
    setState(() { _chargement = true; _creneauSelectionne = null; });
    final dateStr = '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}';
    final data = await ApiService.get(
      '/coiffeuses/${widget.extra['coiffeuseId']}/creneaux?soin_id=${widget.extra['soinId']}&date=$dateStr',
      auth: true,
    );
    setState(() { _creneaux = List<String>.from(data['creneaux'] ?? []); _chargement = false; });
  }

  String _formatDate(DateTime d) {
    final jours = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    final mois = ['jan', 'fév', 'mar', 'avr', 'mai', 'jun', 'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'];
    return '${jours[d.weekday % 7]} ${d.day} ${mois[d.month - 1]}';
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
                        const Text('Choisir un créneau', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                        Text('${widget.extra['coiffeuseNom']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sélectionner une date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 14,
                        itemBuilder: (context, i) {
                          final d = DateTime.now().add(Duration(days: i + 1));
                          final selectionne = d.day == _date.day && d.month == _date.month;
                          return GestureDetector(
                            onTap: () { setState(() => _date = d); _chargerCreneaux(); },
                            child: Container(
                              width: 56,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: selectionne ? const Color(0xFF1C1C1C) : const Color(0xFFF9F5F0),
                                borderRadius: BorderRadius.circular(12),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_creneaux.isEmpty && !_chargement ? 'Sélectionnez une date' : '${_creneaux.length} créneaux disponibles',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                  if (!_chargement && _creneaux.isEmpty)
                    GestureDetector(
                      onTap: _chargerCreneaux,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(999)),
                        child: const Text('Voir', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : _creneaux.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 48, color: Color(0xFFE5E5E5)),
                              SizedBox(height: 12),
                              Text('Aucun créneau disponible', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 14)),
                              SizedBox(height: 4),
                              Text('Essayez une autre date', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 2.2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                          itemCount: _creneaux.length,
                          itemBuilder: (context, i) {
                            final selectionne = _creneaux[i] == _creneauSelectionne;
                            return GestureDetector(
                              onTap: () => setState(() => _creneauSelectionne = _creneaux[i]),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectionne ? const Color(0xFF1C1C1C) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: selectionne ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                                ),
                                child: Center(
                                  child: Text(_creneaux[i], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selectionne ? Colors.white : const Color(0xFF1C1C1C))),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            if (_creneauSelectionne != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () => context.push('/paiement', extra: {
                    ...widget.extra,
                    'dateHeure': '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}T$_creneauSelectionne:00',
                    'type': 'salon',
                  }),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Confirmer $_creneauSelectionne • ${_formatDate(_date)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}