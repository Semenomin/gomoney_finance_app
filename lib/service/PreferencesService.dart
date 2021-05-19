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

  void setToken(String token) {
    _prefs?.setString("token", token);
  }

  String? getToken() {
    return _prefs?.getString("token");
  }

  void deleteToken() {
    _prefs?.remove("token");
  }

  void setName(String name) {
    _prefs?.setString("name", name);
  }

  String? getName() {
    return _prefs?.getString("name");
  }

  void deleteName() {
    _prefs?.remove("name");
  }

  void setDateOfLastBackup(DateTime date) {
    _prefs?.setString("dateOfLastBackup", date.toString());
  }

  DateTime? getDateOfLastBackup() {
    return DateTime.tryParse(
        _prefs?.getString("dateOfLastBackup") ?? "dsdsdsdsdsds");
  }

  void deleteDateOfLastBackup() {
    _prefs?.remove("dateOfLastBackup");
  }
}
