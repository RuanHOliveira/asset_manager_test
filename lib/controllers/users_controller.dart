import 'package:asset_manager_test/database/dao/users_dao.dart';
import 'package:asset_manager_test/models/user.dart';

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

  Future<User?> getUserByCpf({required String cpf}) async {
    return await usersDao.getUserByCpf(cpf: cpf);
  }

  Future<User?> getUserById({required String id}) async {
    return await usersDao.getUserById(id: id);
  }

  Future<List<User>?> getAllUsers() async {
    return await usersDao.getAllUsers();
  }
}
