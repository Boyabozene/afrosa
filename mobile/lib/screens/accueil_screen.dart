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
    final role = prefs.getString('role') ?? '';
    setState(() => _prenom = prefs.getString('prenom') ?? '');
    if (role == 'admin' && mounted) {
      context.go('/admin/dashboard');
    } else if (role == 'coiffeuse' && mounted) {
      context.go('/pro/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildHero(),
          _buildBadges(),
          _buildServices(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Afrosa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C), letterSpacing: -0.5)),
          GestureDetector(
            onTap: () => context.push('/profil'),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1C1C1C).withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 12, color: Color(0xFF7B2238)),
                SizedBox(width: 6),
                Text('Salon de coiffure afro premium', style: TextStyle(fontSize: 12, color: Color(0xFF1C1C1C))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _prenom.isNotEmpty ? 'Bonjour,\n$_prenom 👋' : 'Sublimez\nvos cheveux.',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C), height: 1.1, letterSpacing: -1),
          ),
          const SizedBox(height: 12),
          const Text(
            'Réservez en salon, commandez à domicile ou louez une coiffeuse pour vos événements.',
            style: TextStyle(fontSize: 15, color: Color(0xFF6B6B6B), height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/salons'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Réserver', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/mes-reservations'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1C1C1C)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Mes RDV', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1C1C1C), fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          _badge(Icons.verified, '100% Pro', 'Coiffeuses certifiées'),
          const SizedBox(width: 16),
          _badge(Icons.cancel_outlined, 'Annulation', 'Gratuite 24h avant'),
          const SizedBox(width: 16),
          _badge(Icons.home, 'Domicile', 'Disponible à Kinshasa'),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String titre, String sous) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF7B2238)),
          const SizedBox(height: 6),
          Text(titre, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
          Text(sous, style: const TextStyle(fontSize: 10, color: Color(0xFF6B6B6B))),
        ],
      ),
    );
  }

  Widget _buildServices() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Color(0xFFE5E5E5)),
          const SizedBox(height: 16),
          const Text('Nos services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
          const SizedBox(height: 16),
          _serviceCard('💇‍♀️', 'Réserver en salon', 'Choisissez parmi nos 3 salons à Kinshasa', '/salons'),
          _serviceCard('🏠', 'Soin à domicile', 'Une coiffeuse se déplace chez vous', '/domicile/soin'),
          _serviceCard('✨', 'Louer une coiffeuse', 'Pour mariages, soirées et événements', '/location'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _serviceCard(String emoji, String titre, String description, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: const Color(0xFFF9F5F0), borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C))),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF6B6B6B)),
          ],
        ),
      ),
    );
  }
}