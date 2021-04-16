import 'package:encrypt/encrypt.dart';

class EncryptService {
  static void encrypt(String text) {
    final plainText = text;
    final key = Key.fromUtf8("7XLZ6xyFMtY5cnGUiHi0Q4YV48gsJaPA");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(decrypted);
    print(encrypted.base64);
  }
}
