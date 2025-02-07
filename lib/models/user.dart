class User {
  final int? id;
  final String? cpf;
  final String? name;
  final String? password;
  final int? type;
  final int? status;

  const User(
    this.id,
    this.cpf,
    this.name,
    this.password,
    this.type,
    this.status,
  );

  User.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        cpf = map["cpf"],
        name = map["name"],
        password = map["password"],
        type = map["type"],
        status = map["status"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["id"] = id;
    user["cpf"] = cpf;
    user["name"] = name;
    user["password"] = password;
    user["type"] = type;
    user["status"] = status;
    return user;
  }
}
