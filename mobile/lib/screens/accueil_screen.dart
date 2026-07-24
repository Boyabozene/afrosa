import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  String _prenom = '';

  @override
  void initState() {
    super.initState();
    _chargerProfil();
  }

  Future<void> _chargerProfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _prenom = prefs.getString('prenom') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afrosa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profil'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour${_prenom.isNotEmpty ? ' $_prenom' : ''} 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
            const SizedBox(height: 8),
            const Text('Que souhaitez-vous faire ?', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            _carteService(context, '💇‍♀️', 'Réserver en salon', 'Choisissez un salon, un soin et un créneau', '/salons'),
            const SizedBox(height: 16),
            _carteService(context, '🏠', 'Soin à domicile', 'Une coiffeuse se déplace chez vous', '/domicile/soin'),
            const SizedBox(height: 16),
            _carteService(context, '✨', 'Louer une coiffeuse', 'Pour vos événements spéciaux', '/location'),
            const SizedBox(height: 16),
            _carteService(context, '📋', 'Mes réservations', 'Consulter votre historique', '/mes-reservations'),
          ],
        ),
      ),
    );
  }

  Widget _carteService(BuildContext context, String emoji, String titre, String description, String route) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1C))),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7B2238)),
          ],
        ),
      ),
    );
  }
}