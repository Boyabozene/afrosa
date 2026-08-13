import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormulaireLocationScreen extends StatefulWidget {
  final Map<String, dynamic> coiffeuse;
  const FormulaireLocationScreen({super.key, required this.coiffeuse});
  @override
  State<FormulaireLocationScreen> createState() => _FormulaireLocationScreenState();
}

class _FormulaireLocationScreenState extends State<FormulaireLocationScreen> {
  final _evenementController = TextEditingController();
  final _adresseController = TextEditingController();
  DateTime _dateDebut = DateTime.now().add(const Duration(days: 7));
  DateTime _dateFin = DateTime.now().add(const Duration(days: 7));
  int _nbCoiffeuses = 1;

  int get _nbJours => _dateFin.difference(_dateDebut).inDays + 1;

  int get _remisePourcentage {
    if (_nbCoiffeuses >= 4) return 20;
    if (_nbCoiffeuses == 3) return 15;
    if (_nbCoiffeuses == 2) return 10;
    return 0;
  }

  double get _montant {
    final base = double.parse(widget.coiffeuse['tarif_journee'].toString()) * _nbJours * _nbCoiffeuses;
    return base * (1 - _remisePourcentage / 100);
  }

  bool get _formValide => _evenementController.text.trim().isNotEmpty && _adresseController.text.trim().isNotEmpty;

  String _initiales(String prenom, String nom) {
    return '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'.toUpperCase();
  }

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
                  Expanded(
                    child: Text('${widget.coiffeuse['prenom']} ${widget.coiffeuse['nom']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E5E5))),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(24)),
                      child: Center(child: Text(_initiales(widget.coiffeuse['prenom'] ?? '', widget.coiffeuse['nom'] ?? ''),
                        style: const TextStyle(color: Color(0xFFF5C97A), fontWeight: FontWeight.w700))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.coiffeuse['tarif_journee']}\$ / jour', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                          Text(widget.coiffeuse['salon_nom'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("Type d'événement", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              TextField(
                controller: _evenementController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Mariage, soirée, shooting...',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Adresse de l'événement", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              TextField(
                controller: _adresseController,
                onChanged: (_) => setState(() {}),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Quartier, avenue, référence...',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date début', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final d = await showDatePicker(context: context, initialDate: _dateDebut, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                            if (d != null) setState(() { _dateDebut = d; if (_dateFin.isBefore(d)) _dateFin = d; });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_dateDebut.day}/${_dateDebut.month}/${_dateDebut.year}', style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1C))),
                                const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF6B6B6B)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date fin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final d = await showDatePicker(context: context, initialDate: _dateFin, firstDate: _dateDebut, lastDate: DateTime.now().add(const Duration(days: 365)));
                            if (d != null) setState(() => _dateFin = d);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_dateFin.day}/${_dateFin.month}/${_dateFin.year}', style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1C))),
                                const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF6B6B6B)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Nombre de coiffeuses', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _remisePourcentage > 0 ? '-$_remisePourcentage% de remise appliquée' : 'À partir de 2, remise automatique',
                        style: TextStyle(fontSize: 12, color: _remisePourcentage > 0 ? const Color(0xFF7B2238) : const Color(0xFF9B9B9B), fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _nbCoiffeuses = _nbCoiffeuses > 1 ? _nbCoiffeuses - 1 : 1),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.remove, size: 16, color: Color(0xFF1C1C1C)),
                      ),
                    ),
                    SizedBox(width: 32, child: Text('$_nbCoiffeuses', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C)))),
                    GestureDetector(
                      onTap: () => setState(() => _nbCoiffeuses = _nbCoiffeuses < 10 ? _nbCoiffeuses + 1 : 10),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$_nbJours jour${_nbJours > 1 ? 's' : ''} • $_nbCoiffeuses coiffeuse${_nbCoiffeuses > 1 ? 's' : ''}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    Text('${_montant.toStringAsFixed(2)} USD', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFFF5C97A))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: !_formValide ? null : () => context.push('/paiement', extra: {
                  'type': 'location',
                  'coiffeuseId': widget.coiffeuse['id'],
                  'coiffeuseNom': '${widget.coiffeuse['prenom']} ${widget.coiffeuse['nom']}',
                  'typeEvenement': _evenementController.text.trim(),
                  'adresseEvenement': _adresseController.text.trim(),
                  'dateDebut': '${_dateDebut.year}-${_dateDebut.month.toString().padLeft(2,'0')}-${_dateDebut.day.toString().padLeft(2,'0')}',
                  'dateFin': '${_dateFin.year}-${_dateFin.month.toString().padLeft(2,'0')}-${_dateFin.day.toString().padLeft(2,'0')}',
                  'montant': _montant,
                  'nbCoiffeuses': _nbCoiffeuses,
                }),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: !_formValide ? const Color(0xFF6B6B6B) : const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Procéder au paiement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
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