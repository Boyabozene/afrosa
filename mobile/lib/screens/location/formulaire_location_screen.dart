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
  String _devise = 'USD';

  int get _nbJours => _dateFin.difference(_dateDebut).inDays + 1;
  double get _montant => double.parse(widget.coiffeuse['tarif_journee'].toString()) * _nbJours;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.coiffeuse['prenom']} ${widget.coiffeuse['nom']}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _evenementController, decoration: const InputDecoration(labelText: 'Type d\'événement (mariage, soirée...)')),
            const SizedBox(height: 16),
            TextField(controller: _adresseController, decoration: const InputDecoration(labelText: 'Adresse de l\'événement'), maxLines: 2),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Début : ${_dateDebut.day}/${_dateDebut.month}/${_dateDebut.year}'),
              trailing: const Icon(Icons.calendar_today, color: Color(0xFF7B2238)),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _dateDebut, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _dateDebut = d);
              },
            ),
            ListTile(
              title: Text('Fin : ${_dateFin.day}/${_dateFin.month}/${_dateFin.year}'),
              trailing: const Icon(Icons.calendar_today, color: Color(0xFF7B2238)),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _dateFin, firstDate: _dateDebut, lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _dateFin = d);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _devise,
              decoration: const InputDecoration(labelText: 'Devise'),
              items: const [
                DropdownMenuItem(value: 'USD', child: Text('Dollar (USD)')),
                DropdownMenuItem(value: 'CDF', child: Text('Franc congolais (CDF)')),
              ],
              onChanged: (v) => setState(() => _devise = v!),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFAE8C8), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$_nbJours jour(s)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_devise == 'USD' ? _montant.toStringAsFixed(2) : (_montant * 2200).toStringAsFixed(0)} $_devise', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => context.go('/paiement', extra: {
                'type': 'location',
                'coiffeuseId': widget.coiffeuse['id'],
                'coiffeuseNom': '${widget.coiffeuse['prenom']} ${widget.coiffeuse['nom']}',
                'typeEvenement': _evenementController.text,
                'adresseEvenement': _adresseController.text,
                'dateDebut': '${_dateDebut.year}-${_dateDebut.month.toString().padLeft(2,'0')}-${_dateDebut.day.toString().padLeft(2,'0')}',
                'dateFin': '${_dateFin.year}-${_dateFin.month.toString().padLeft(2,'0')}-${_dateFin.day.toString().padLeft(2,'0')}',
                'montant': _devise == 'USD' ? _montant : _montant * 2200,
                'devise': _devise,
              }),
              child: const Text('Procéder au paiement'),
            )),
          ],
        ),
      ),
    );
  }
}