import 'package:encrypt/encrypt.dart';

class AES128CryptoHelperUtil {
  /// private constructor
  AES128CryptoHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = AES128CryptoHelperUtil._();

  ///decryption using the AES 128 CBC
  ///using the 16-bit keys
  ///secret and the IV
  String decrypt({required String encryptedValue, required String secret, required String iv}) {
    final secretFromBase64 = Key.fromBase64(secret);
    final ivFromBase64 = IV.fromBase64(iv);

    final encryptor = Encrypter(AES(secretFromBase64, mode: AESMode.cbc));
    Encrypted enBase64 = Encrypted.fromBase64(encryptedValue);
    final decrypted = encryptor.decrypt(enBase64, iv: ivFromBase64);
    return decrypted;
  }

  ///encryption using the AES 128 CBC
  ///using the 16-bit keys
  ///secret and the IV
  String encrypt({required String plainText, required String secret, required String iv}) {
    final secretFromBase64 = Key.fromBase64(secret);
    final ivFromBase64 = IV.fromBase64(iv);

    final encryptor = Encrypter(AES(secretFromBase64, mode: AESMode.cbc));
    final encrypted = encryptor.encrypt(plainText, iv: ivFromBase64);
    return encrypted.base64;
  }
}
