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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Votre adresse')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _adresseController, decoration: const InputDecoration(labelText: 'Adresse complète'), maxLines: 3),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Date : ${_date.day}/${_date.month}/${_date.year}'),
              trailing: const Icon(Icons.calendar_today, color: Color(0xFF7B2238)),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60)));
                if (d != null) setState(() => _date = d);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => context.go('/paiement', extra: {
                ...widget.extra,
                'adresse': _adresseController.text,
                'dateHeure': '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}T09:00:00',
                'type': 'domicile',
              }),
              child: const Text('Continuer vers le paiement'),
            )),
          ],
        ),
      ),
    );
  }
}