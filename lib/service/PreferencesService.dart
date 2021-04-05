import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  SharedPreferences? _prefs;

  Future<PreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  void clearAll() {
    deleteToken();
  }

////////////////////////////////////////////////////////////////////////////////
//*                                 Token
////////////////////////////////////////////////////////////////////////////////

  void setToken(String token) {
    _prefs?.setString("token", token);
  }

  String? getToken() {
    return _prefs?.getString("token");
  }

  void deleteToken() {
    _prefs?.remove("token");
  }
}
