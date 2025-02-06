import 'package:asset_manager_test/database/dao/users_dao.dart';

class UsersController {
  final UsersDao usersDao = UsersDao();

  Future<bool> verifyExistUserByCpf({required String cpf}) async {
    return await usersDao.verifyExistUserByCpf(cpf: cpf);
  }

  Future<bool> registerUser({
    required String name,
    required String cpf,
    required String password,
  }) async {
    return await usersDao.registerUser(
      name: name,
      cpf: cpf,
      password: password,
    );
  }

  Future<bool> tryLogin({
    required String cpf,
    required String password,
  }) async {
    return await usersDao.tryLogin(cpf: cpf, password: password);
  }
}
