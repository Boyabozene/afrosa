import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> connexion(String email, String motDePasse) async {
    final data = await ApiService.post('/auth/connexion', {
      'email': email,
      'mot_de_passe': motDePasse,
    });
    if (data['token'] != null) {
      await ApiService.saveToken(data['token']);
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
    }
    return data;
  }

  static Future<void> deconnexion() async {
    await ApiService.removeToken();
  }

  static Future<bool> estConnecte() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}