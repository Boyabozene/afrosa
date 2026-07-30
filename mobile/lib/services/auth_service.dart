import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> connexion(String email, String motDePasse) async {
    final data = await ApiService.post('/auth/connexion', {
      'email': email,
      'mot_de_passe': motDePasse,
    });
    if (data['token'] != null) {
      await ApiService.saveToken(data['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', data['utilisateur']['role'] ?? 'cliente');
      await prefs.setString('prenom', data['utilisateur']['prenom'] ?? '');
    }
    return data;
  }

  static Future<Map<String, dynamic>> inscription(String nom, String prenom, String email, String motDePasse, String telephone) async {
    final data = await ApiService.post('/auth/inscription', {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'mot_de_passe': motDePasse,
      'telephone': telephone,
    });
    if (data['token'] != null) {
      await ApiService.saveToken(data['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', data['utilisateur']['role'] ?? 'cliente');
      await prefs.setString('prenom', data['utilisateur']['prenom'] ?? '');
    }
    return data;
  }

  static Future<void> deconnexion() async {
    await ApiService.removeToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await prefs.remove('prenom');
  }

  static Future<bool> estConnecte() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}