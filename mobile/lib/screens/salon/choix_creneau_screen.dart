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

  Future<void> _chargerCreneaux() async {
    setState(() => _chargement = true);
    final dateStr = '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}';
    final data = await ApiService.get('/coiffeuses/${widget.extra['coiffeuseId']}/creneaux?soin_id=${widget.extra['soinId']}&date=$dateStr', auth: true);
    setState(() { _creneaux = List<String>.from(data['creneaux'] ?? []); _chargement = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir un créneau')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('Date : ${_date.day}/${_date.month}/${_date.year}'),
              trailing: const Icon(Icons.calendar_today, color: Color(0xFF7B2238)),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60)));
                if (d != null) { setState(() => _date = d); _chargerCreneaux(); }
              },
            ),
            ElevatedButton(onPressed: _chargerCreneaux, child: const Text('Voir les créneaux')),
            const SizedBox(height: 16),
            if (_chargement) const CircularProgressIndicator()
            else Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: _creneaux.length,
                itemBuilder: (context, i) => ElevatedButton(
                  onPressed: () => context.go('/paiement', extra: {
                    ...widget.extra,
                    'dateHeure': '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}T${_creneaux[i]}:00',
                    'type': 'salon',
                  }),
                  child: Text(_creneaux[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}