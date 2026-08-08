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
  bool _mdpVisible = false;
  String? _erreur;

  Future<void> _inscription() async {
    setState(() { _chargement = true; _erreur = null; });
    try {
      final data = await AuthService.inscription(
        _nomController.text.trim(), _prenomController.text.trim(),
        _emailController.text.trim(), _mdpController.text, _telController.text.trim(),
      );
      if (data['token'] != null && mounted) {
        context.go('/accueil');
      } else {
        setState(() => _erreur = data['message'] ?? 'Erreur inscription');
      }
    } catch (e) {
      setState(() => _erreur = 'Erreur réseau. Vérifiez votre connexion.');
    } finally {
      setState(() => _chargement = false);
    }
  }

  Widget _champ(String label, String hint, TextEditingController controller, {TextInputType type = TextInputType.text, bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscure && !_mdpVisible,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: obscure ? IconButton(
              icon: Icon(_mdpVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF6B6B6B), size: 20),
              onPressed: () => setState(() => _mdpVisible = !_mdpVisible),
            ) : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
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
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => context.go('/connexion'),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                  child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF1C1C1C)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Créer un compte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C), letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text('Rejoignez Afrosa en quelques secondes', style: TextStyle(fontSize: 15, color: Color(0xFF6B6B6B))),
              const SizedBox(height: 32),
              if (_erreur != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFCCCC)),
                  ),
                  child: Text(_erreur!, style: const TextStyle(color: Color(0xFFCC0000), fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(child: _champ('Nom', 'Bozene', _nomController)),
                  const SizedBox(width: 12),
                  Expanded(child: _champ('Prénom', 'Akira', _prenomController)),
                ],
              ),
              _champ('Email', 'votre@email.com', _emailController, type: TextInputType.emailAddress),
              _champ('Téléphone', '+243 8XX XXX XXX', _telController, type: TextInputType.phone),
              _champ('Mot de passe', '••••••••', _mdpController, obscure: true),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _chargement ? null : _inscription,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _chargement ? const Color(0xFF6B6B6B) : const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _chargement
                        ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("S'inscrire", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                            ],
                          ),
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
}