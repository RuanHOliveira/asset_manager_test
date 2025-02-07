class Asset {
  final int? id;
  final String? name;
  final String? code;
  final int? userId;
  final String? dtInventory;
  final int? status;

  const Asset(
    this.id,
    this.name,
    this.code,
    this.userId,
    this.dtInventory,
    this.status,
  );

  Asset.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        code = map["code"],
        userId = map["userId"],
        dtInventory = map["dtInventory"],
        status = map["status"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> asset = <String, dynamic>{};
    asset["id"] = id;
    asset["name"] = name;
    asset["code"] = code;
    asset["userId"] = userId;
    asset["dtInventory"] = dtInventory;
    asset["status"] = status;
    return asset;
  }
}
