import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Group {
  final String id;
  final String name;
  final String key;
  final String iv;

  Group._({this.id, this.name, this.key, this.iv});

  static fromFullCode(String code) {
    final parts = code.split('^');
    return Group._(id: parts[0], name: parts[1], key: parts[2], iv: parts[3]);
  }

  static fromValueMap(Map<String, dynamic> values) {
    return Group._(id: values['id'], name: values['name'], key: values['key'], iv: values['iv']);
  }

  static newGroup(String name) {
    final id = uuid.v1();
    final key = Encrypt.Key.fromSecureRandom(32);
    final iv = Encrypt.IV.fromSecureRandom(8);
    return Group._(id: id, name: name, key: key.base64, iv: iv.base64);
  }

  String getFullCode() {
    return id + '^' + name + '^' + key + '^' + iv + '^';
  }

  Map<String, dynamic> getValueMap() {
    return {'id': id, 'name': name, 'key': key, 'iv': iv};
  }

  String encrypt(String message) {
    return getEncrypter().encrypt(message, iv: getIVObject()).base64;
  }

  String decrypt(String message) {
    return getEncrypter().decrypt64(message, iv: getIVObject());
  }

  Encrypt.Encrypter getEncrypter() {
    final keyObj = Encrypt.Key.fromBase64(key);
    return Encrypt.Encrypter(Encrypt.Salsa20(keyObj));
  }

  Encrypt.IV getIVObject() {
    return Encrypt.IV.fromBase64(iv);
  }
}