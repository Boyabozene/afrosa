import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _mdpController = TextEditingController();
  final _telController = TextEditingController();
  bool _chargement = false;
  String? _erreur;

  Future<void> _inscription() async {
    setState(() { _chargement = true; _erreur = null; });
    try {
      final data = await AuthService.inscription(
        _nomController.text, _prenomController.text,
        _emailController.text, _mdpController.text, _telController.text,
      );
      if (data['token'] != null && mounted) {
        context.go('/accueil');
      } else {
        setState(() => _erreur = data['message'] ?? 'Erreur inscription');
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
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_erreur != null) Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: Text(_erreur!, style: const TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 16),
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 16),
            TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 16),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            TextField(controller: _telController, decoration: const InputDecoration(labelText: 'Téléphone'), keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            TextField(controller: _mdpController, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: _chargement ? null : _inscription,
              child: _chargement ? const CircularProgressIndicator(color: Colors.white) : const Text("S'inscrire"),
            )),
            TextButton(
              onPressed: () => context.go('/connexion'),
              child: const Text('Déjà un compte ? Se connecter', style: TextStyle(color: Color(0xFF7B2238))),
            ),
          ],
        ),
      ),
    );
  }
}