import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class PaiementScreen extends StatefulWidget {
  final Map<String, dynamic> extra;
  const PaiementScreen({super.key, required this.extra});
  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  final _carteController = TextEditingController(text: '4242 4242 4242 4242');
  final _expController = TextEditingController(text: '12/27');
  final _cvvController = TextEditingController(text: '123');
  String _modePaiement = 'carte';
  bool _chargement = false;
  bool _paye = false;
  String? _erreur;

  Future<void> _payer() async {
    setState(() { _chargement = true; _erreur = null; });
    try {
      final type = widget.extra['type'];
      Map<String, dynamic> body = {};
      String endpoint = '';

      if (type == 'salon') {
        endpoint = '/reservations/salon';
        body = {
          'coiffeuse_id': widget.extra['coiffeuseId'],
          'salon_id': widget.extra['salonId'],
          'soin_id': widget.extra['soinId'],
          'date_heure': widget.extra['dateHeure'],
          'devise': widget.extra['devise'] ?? 'USD',
        };
      } else if (type == 'domicile') {
        endpoint = '/reservations/domicile';
        body = {
          'coiffeuse_id': widget.extra['coiffeuseId'],
          'soin_id': widget.extra['soinId'],
          'adresse_cliente': widget.extra['adresse'],
          'date_heure': widget.extra['dateHeure'],
          'devise': widget.extra['devise'] ?? 'USD',
        };
      } else if (type == 'location') {
        endpoint = '/locations';
        body = {
          'coiffeuse_id': widget.extra['coiffeuseId'],
          'type_evenement': widget.extra['typeEvenement'],
          'date_debut': widget.extra['dateDebut'],
          'date_fin': widget.extra['dateFin'],
          'adresse_evenement': widget.extra['adresseEvenement'],
          'devise': widget.extra['devise'] ?? 'USD',
        };
      }

      final data = await ApiService.post(endpoint, body, auth: true);
      if (data['id'] != null) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() { _paye = true; });
      } else {
        setState(() => _erreur = data['message'] ?? 'Erreur');
      }
    } catch (e) {
      setState(() => _erreur = 'Erreur réseau');
    } finally {
      setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_paye) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 48, color: Colors.green),
              ),
              const SizedBox(height: 24),
              const Text('Paiement accepté', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Simulation — aucun montant débité', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/mes-reservations'),
                child: const Text('Voir mes réservations'),
              ),
              TextButton(
                onPressed: () => context.go('/accueil'),
                child: const Text('Retour à l\'accueil', style: TextStyle(color: Color(0xFF7B2238))),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFAE8C8), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.extra['soinNom'] ?? widget.extra['typeEvenement'] ?? 'Réservation', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Avec ${widget.extra['coiffeuseNom'] ?? ''}', style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text('${widget.extra['montant'] ?? ''} ${widget.extra['devise'] ?? 'USD'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Mode de paiement', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => setState(() => _modePaiement = 'carte'),
                  icon: const Icon(Icons.credit_card),
                  label: const Text('Carte'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _modePaiement == 'carte' ? const Color(0xFFFAE8C8) : null,
                    side: BorderSide(color: _modePaiement == 'carte' ? const Color(0xFF7B2238) : Colors.grey),
                  ),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => setState(() => _modePaiement = 'paypal'),
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('PayPal'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _modePaiement == 'paypal' ? const Color(0xFFFAE8C8) : null,
                    side: BorderSide(color: _modePaiement == 'paypal' ? const Color(0xFF7B2238) : Colors.grey),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Numéro de carte', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            TextField(controller: _carteController, decoration: const InputDecoration()),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Expiration', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    TextField(controller: _expController, decoration: const InputDecoration()),
                  ],
                )),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CVV', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    TextField(controller: _cvvController, decoration: const InputDecoration()),
                  ],
                )),
              ],
            ),
            if (_erreur != null) ...[
              const SizedBox(height: 12),
              Text(_erreur!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: _chargement ? null : _payer,
              child: _chargement
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Payer ${widget.extra['montant'] ?? ''} ${widget.extra['devise'] ?? 'USD'}'),
            )),
            const SizedBox(height: 12),
            const Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('Paiement sécurisé • mode démo', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}