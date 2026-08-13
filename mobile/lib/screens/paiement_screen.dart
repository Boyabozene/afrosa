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
  String _devise = 'USD';
  bool _chargement = false;
  bool _paye = false;
  String? _erreur;

  int get _remisePourcentage {
    final nb = (widget.extra['nbPersonnes'] ?? widget.extra['nbCoiffeuses'] ?? 1) as int;
    if (nb >= 4) return 20;
    if (nb == 3) return 15;
    if (nb == 2) return 10;
    return 0;
  }

  double get _montant {
    final m = widget.extra['montant'];
    if (m == null) return 0;
    final base = double.tryParse(m.toString()) ?? 0;
    final type = widget.extra['type'];
    if (type == 'salon') {
      final nb = (widget.extra['nbPersonnes'] ?? 1) as int;
      return base * nb * (1 - _remisePourcentage / 100);
    }
    return base;
  }

  double get _montantAffiche => _devise == 'CDF' ? _montant * 2200 : _montant;
  String get _deviseLabel => _devise == 'CDF' ? 'CDF' : 'USD';

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
          'devise': _devise,
          'nb_personnes': widget.extra['nbPersonnes'] ?? 1,
        };
      } else if (type == 'domicile') {
        endpoint = '/reservations/domicile';
        body = {
          'coiffeuse_id': widget.extra['coiffeuseId'],
          'soin_id': widget.extra['soinId'],
          'adresse_cliente': widget.extra['adresse'],
          'date_heure': widget.extra['dateHeure'],
          'devise': _devise,
        };
      } else if (type == 'location') {
        endpoint = '/locations';
        body = {
          'coiffeuse_id': widget.extra['coiffeuseId'],
          'type_evenement': widget.extra['typeEvenement'],
          'date_debut': widget.extra['dateDebut'],
          'date_fin': widget.extra['dateFin'],
          'adresse_evenement': widget.extra['adresseEvenement'],
          'devise': _devise,
          'nb_coiffeuses': widget.extra['nbCoiffeuses'] ?? 1,
        };
      }
      final data = await ApiService.post(endpoint, body, auth: true);
      if (data['id'] != null) {
        await Future.delayed(const Duration(milliseconds: 800));
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
        backgroundColor: const Color(0xFFF9F5F0),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(40)),
                    child: const Icon(Icons.check, size: 40, color: Color(0xFFF5C97A)),
                  ),
                  const SizedBox(height: 24),
                  const Text('Paiement accepté', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C))),
                  const SizedBox(height: 8),
                  const Text('Simulation — aucun montant débité', style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5E5E5)), borderRadius: BorderRadius.circular(999)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, size: 12, color: Color(0xFF6B6B6B)),
                        SizedBox(width: 4),
                        Text('Mode démo', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  GestureDetector(
                    onTap: () => context.go('/mes-reservations'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Voir mes réservations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => context.go('/accueil'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5E5E5)), borderRadius: BorderRadius.circular(12)),
                      child: const Text("Retour à l'accueil", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1C1C1C), fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                  const Text('Paiement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.extra['soinNom'] ?? widget.extra['typeEvenement'] ?? 'Réservation',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Avec ${widget.extra['coiffeuseNom'] ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.white60)),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 14, color: Colors.white70)),
                        Text(
                          '${_montantAffiche.toStringAsFixed(_devise == 'CDF' ? 0 : 2)} $_deviseLabel',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFF5C97A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Devise', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() => _devise = 'USD'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _devise == 'USD' ? const Color(0xFF1C1C1C) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _devise == 'USD' ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                      ),
                      child: Text('Dollar USD', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _devise == 'USD' ? Colors.white : const Color(0xFF6B6B6B))),
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() => _devise = 'CDF'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _devise == 'CDF' ? const Color(0xFF1C1C1C) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _devise == 'CDF' ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                      ),
                      child: Text('Franc CDF', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _devise == 'CDF' ? Colors.white : const Color(0xFF6B6B6B))),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Mode de paiement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() => _modePaiement = 'carte'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _modePaiement == 'carte' ? const Color(0xFF1C1C1C) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _modePaiement == 'carte' ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card, size: 16, color: _modePaiement == 'carte' ? Colors.white : const Color(0xFF6B6B6B)),
                          const SizedBox(width: 6),
                          Text('Carte', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _modePaiement == 'carte' ? Colors.white : const Color(0xFF6B6B6B))),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() => _modePaiement = 'paypal'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _modePaiement == 'paypal' ? const Color(0xFF1C1C1C) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _modePaiement == 'paypal' ? const Color(0xFF1C1C1C) : const Color(0xFFE5E5E5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 16, color: _modePaiement == 'paypal' ? Colors.white : const Color(0xFF6B6B6B)),
                          const SizedBox(width: 6),
                          Text('PayPal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _modePaiement == 'paypal' ? Colors.white : const Color(0xFF6B6B6B))),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Numéro de carte', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              TextField(
                controller: _carteController,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: const Icon(Icons.credit_card_outlined, color: Color(0xFF6B6B6B)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expiration', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _expController,
                        decoration: InputDecoration(
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CVV', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cvvController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              if (_erreur != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFFF0F0), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFCCCC))),
                  child: Text(_erreur!, style: const TextStyle(color: Color(0xFFCC0000), fontSize: 13)),
                ),
              ],
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _chargement ? null : _payer,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _chargement ? const Color(0xFF6B6B6B) : const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _chargement
                      ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Payer ${_montantAffiche.toStringAsFixed(_devise == 'CDF' ? 0 : 2)} $_deviseLabel',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.lock_outline, color: Colors.white, size: 16),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 12, color: Color(0xFF6B6B6B)),
                    SizedBox(width: 4),
                    Text('Paiement sécurisé • mode démo', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                  ],
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