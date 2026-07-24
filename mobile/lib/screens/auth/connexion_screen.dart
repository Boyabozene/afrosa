import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _emailController = TextEditingController();
  final _mdpController = TextEditingController();
  bool _chargement = false;
  String? _erreur;

  Future<void> _connexion() async {
    setState(() { _chargement = true; _erreur = null; });
    try {
      final data = await AuthService.connexion(_emailController.text, _mdpController.text);
      if (data['token'] != null && mounted) {
        context.go('/accueil');
      } else {
        setState(() => _erreur = data['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      setState(() => _erreur = 'Erreur réseau');
    } finally {
      setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Afrosa', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF7B2238))),
              const SizedBox(height: 8),
              const Text('Salon de coiffure afro', style: TextStyle(fontSize: 16, color: Color(0xFFC4622D))),
              const SizedBox(height: 48),
              if (_erreur != null) Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text(_erreur!, style: const TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 16),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              TextField(controller: _mdpController, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: _chargement ? null : _connexion,
                child: _chargement ? const CircularProgressIndicator(color: Colors.white) : const Text('Se connecter'),
              )),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/inscription'),
                child: const Text("Pas de compte ? S'inscrire", style: TextStyle(color: Color(0xFF7B2238))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}