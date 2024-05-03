class Avatar {
  final String Objectid;
  final String name;
  final String path;
  final String extension;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;

  Avatar({
    required this.Objectid,
    required this.name,
    required this.path,
    required this.extension,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      Objectid: json['Objectid'],
      name: json['name'],
      path: json['path'],
      extension: json['extension'],
      size: json['size'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Objectid': Objectid,
      'name': name,
      'path': path,
      'extension': extension,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
