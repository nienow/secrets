import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class KeyService {
  // make this a singleton class
  KeyService._privateConstructor();
  static final KeyService instance = KeyService._privateConstructor();

  final storage = new FlutterSecureStorage();

  String generateKey(int contactId) {
    final key = Encrypt.Key.fromLength(32);
    final iv = Encrypt.IV.fromLength(8);
    print('key: ' + key.base64);
    print('iv: ' + iv.base64);
    final combinedKey = key.base64 + '_' + iv.base64;
    storage.write(key: contactId.toString(), value: combinedKey);
    return combinedKey;
  }

  Future<String> getKey(String contactId) async {
    return storage.read(key: contactId);
  }
}