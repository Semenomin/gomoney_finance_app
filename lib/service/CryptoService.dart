import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptService {
  static const SECRET_KEY = "2020_PRIVATES_KEYS_ENCRYPTS_2020";

  static String encryptText(String json) {
    final key = encrypt.Key.fromUtf8(SECRET_KEY);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(json, iv: iv);
    return encrypted.base64;
  }

  static String decryptText(String text) {
    final key = encrypt.Key.fromUtf8(SECRET_KEY);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(text, iv: iv);
  }
}
