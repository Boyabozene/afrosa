import '../main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});
  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String _prenom = '';
  String _nom = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _chargerProfil();
  }

  Future<void> _chargerProfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prenom = prefs.getString('prenom') ?? '';
      _nom = prefs.getString('nom') ?? '';
      _email = prefs.getString('email') ?? '';
    });
  }

  String get _initiales {
    final p = _prenom.isNotEmpty ? _prenom[0] : '';
    final n = _nom.isNotEmpty ? _nom[0] : '';
    return '$p$n'.toUpperCase();
  }

  void _confirmerDeconnexion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Se déconnecter ?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text('Vous devrez vous reconnecter pour accéder à votre compte.', style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Color(0xFF6B6B6B))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.deconnexion();
              if (context.mounted) context.go('/connexion');
            },
            child: const Text('Déconnexion', style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
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
              const Text('Mon profil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(color: const Color(0xFFF5C97A), borderRadius: BorderRadius.circular(32)),
                      child: Center(
                        child: Text(_initiales.isEmpty ? '?' : _initiales,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_prenom $_nom'.trim().isEmpty ? 'Utilisateur' : '$_prenom $_nom',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(_email, style: const TextStyle(fontSize: 13, color: Colors.white60)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('COMPTE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9B9B9B), letterSpacing: 0.5)),
              const SizedBox(height: 8),
              _menuItem(Icons.calendar_today_outlined, 'Mes réservations', () {
  dernierOngletVisite.value = StatefulNavigationShell.of(context).currentIndex;
  StatefulNavigationShell.of(context).goBranch(1);
}),
              _menuItem(Icons.person_outline, 'Informations personnelles', null),
              _menuItem(Icons.notifications_outlined, 'Notifications', null),
              const SizedBox(height: 24),
              const Text('SUPPORT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9B9B9B), letterSpacing: 0.5)),
              const SizedBox(height: 8),
              _menuItem(Icons.help_outline, 'Centre d\'aide', null),
              _menuItem(Icons.info_outline, 'À propos d\'Afrosa', null),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _confirmerDeconnexion,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFCCCC)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 18, color: Color(0xFFCC0000)),
                      SizedBox(width: 8),
                      Text('Se déconnecter', style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.w600, fontSize: 15)),
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

  Widget _menuItem(IconData icon, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF7B2238)),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C)))),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF9B9B9B)),
          ],
        ),
      ),
    );
  }
}