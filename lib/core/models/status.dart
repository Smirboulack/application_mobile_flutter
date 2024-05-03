class Status {
  final String? objectId;
  final String? name;

  Status({
    this.objectId,
    this.name,
  });

  factory Status.fromJson(json) {
    return Status(
      name: json['name'],
      objectId: json['objectId'],
    );
  }
}
