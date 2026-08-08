import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/connexion_screen.dart';
import 'screens/auth/inscription_screen.dart';
import 'screens/accueil_screen.dart';
import 'screens/salon/liste_salons_screen.dart';
import 'screens/salon/choix_soin_screen.dart';
import 'screens/salon/choix_coiffeuse_screen.dart';
import 'screens/salon/choix_creneau_screen.dart';
import 'screens/domicile/choix_soin_domicile_screen.dart';
import 'screens/domicile/choix_coiffeuse_domicile_screen.dart';
import 'screens/domicile/adresse_screen.dart';
import 'screens/location/liste_coiffeuses_location_screen.dart';
import 'screens/location/formulaire_location_screen.dart';
import 'screens/paiement_screen.dart';
import 'screens/mes_reservations_screen.dart';
import 'screens/profil_screen.dart';
import 'screens/espace_pro/dashboard_coiffeuse_screen.dart';
import 'screens/espace_pro/admin/dashboard_admin_screen.dart';

void main() {
  runApp(const AfrosaApp());
}

class AfrosaApp extends StatelessWidget {
  const AfrosaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Afrosa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B2238),
          primary: const Color(0xFF7B2238),
          secondary: const Color(0xFFC4622D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F5F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7B2238),
          foregroundColor: Color(0xFFF5C97A),
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/connexion',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final estConnecte = token != null;
    final versAuth = state.matchedLocation == '/connexion' || state.matchedLocation == '/inscription';
    if (!estConnecte && !versAuth) return '/connexion';
    if (estConnecte && versAuth) return '/accueil';
    return null;
  },
  routes: [
    GoRoute(path: '/connexion', builder: (c, s) => const ConnexionScreen()),
    GoRoute(path: '/inscription', builder: (c, s) => const InscriptionScreen()),
    GoRoute(path: '/pro/dashboard', builder: (c, s) => const DashboardCoiffeuseScreen()),
    GoRoute(path: '/admin/dashboard', builder: (c, s) => const DashboardAdminScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/accueil', builder: (c, s) => const AccueilScreen()),
            GoRoute(path: '/salons', builder: (c, s) => const ListeSalonsScreen()),
            GoRoute(path: '/salon/soin', builder: (c, s) => ChoixSoinScreen(salonId: s.extra as String)),
            GoRoute(path: '/salon/coiffeuse', builder: (c, s) => ChoixCoiffeuseScreen(extra: s.extra as Map<String, dynamic>)),
            GoRoute(path: '/salon/creneau', builder: (c, s) => ChoixCreneauScreen(extra: s.extra as Map<String, dynamic>)),
            GoRoute(path: '/domicile/soin', builder: (c, s) => const ChoixSoinDomicileScreen()),
            GoRoute(path: '/domicile/coiffeuse', builder: (c, s) => ChoixCoiffeusesDomicileScreen(soinId: s.extra as String)),
            GoRoute(path: '/domicile/adresse', builder: (c, s) => AdresseScreen(extra: s.extra as Map<String, dynamic>)),
            GoRoute(path: '/location', builder: (c, s) => const ListeCoiffeusesLocationScreen()),
            GoRoute(path: '/location/formulaire', builder: (c, s) => FormulaireLocationScreen(coiffeuse: s.extra as Map<String, dynamic>)),
            GoRoute(path: '/paiement', builder: (c, s) => PaiementScreen(extra: s.extra as Map<String, dynamic>)),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/mes-reservations', builder: (c, s) => const MesReservationsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profil', builder: (c, s) => const ProfilScreen()),
          ],
        ),
      ],
    ),
  ],
);

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, Icons.home_filled, 'Accueil', 0),
                _navItem(context, Icons.calendar_today_outlined, 'Mes RDV', 1),
                _navItem(context, Icons.person_outline, 'Profil', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index) {
    final actif = index == navigationShell.currentIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => navigationShell.goBranch(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: actif ? const Color(0xFF1C1C1C) : const Color(0xFF9B9B9B)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: actif ? FontWeight.w600 : FontWeight.w400, color: actif ? const Color(0xFF1C1C1C) : const Color(0xFF9B9B9B))),
            ],
          ),
        ),
      ),
    );
  }
}