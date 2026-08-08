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
  bool _mdpVisible = false;

  Future<void> _connexion() async {
    setState(() { _chargement = true; _erreur = null; });
    try {
      final data = await AuthService.connexion(_emailController.text.trim(), _mdpController.text);
      if (data['token'] != null && mounted) {
        context.go('/accueil');
      } else {
        setState(() => _erreur = data['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      setState(() => _erreur = 'Erreur réseau. Vérifiez votre connexion.');
    } finally {
      setState(() => _chargement = false);
    }
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
              const SizedBox(height: 60),
              const Text('Afrosa', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1C1C1C), letterSpacing: -1)),
              const SizedBox(height: 8),
              const Text('Connectez-vous pour continuer', style: TextStyle(fontSize: 16, color: Color(0xFF6B6B6B))),
              const SizedBox(height: 48),
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
                const SizedBox(height: 20),
              ],
              const Text('Email', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'votre@email.com',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Mot de passe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1C))),
              const SizedBox(height: 8),
              TextField(
                controller: _mdpController,
                obscureText: !_mdpVisible,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1C), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(_mdpVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF6B6B6B), size: 20),
                    onPressed: () => setState(() => _mdpVisible = !_mdpVisible),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _chargement ? null : _connexion,
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
                              Text('Se connecter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE5E5E5))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('ou', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 13))),
                  const Expanded(child: Divider(color: Color(0xFFE5E5E5))),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => context.go('/inscription'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1C1C1C)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Créer un compte", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1C1C1C), fontWeight: FontWeight.w600, fontSize: 15)),
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