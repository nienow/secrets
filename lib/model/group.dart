class Group {
  final String id;
  final String name;
  final String key;
  final String iv;

  Group({this.id, this.name, this.key, this.iv});

  static fromFullCode(String code) {
    final parts = code.split('^');
    return Group(id: parts[0], name: parts[1], key: parts[2], iv: parts[3]);
  }

  getFullCode() {
    return id + '^' + name + '^' + key + '^' + iv + '^';
  }
}