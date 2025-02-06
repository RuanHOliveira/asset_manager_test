import 'package:asset_manager_test/controllers/users_controller.dart';
import 'package:asset_manager_test/src/common/widgets/buttons/multi_text_button.dart';
import 'package:asset_manager_test/src/common/widgets/buttons/primary_button.dart';
import 'package:asset_manager_test/src/common/widgets/fields/custom_text_form_field.dart';
import 'package:asset_manager_test/src/common/widgets/fields/password_form_field.dart';
import 'package:asset_manager_test/src/pages/home_page.dart';
import 'package:asset_manager_test/src/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final UsersController usersController = UsersController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _tryLogin() async {
    if (_cpfController.text.length < 11) {
      Fluttertoast.showToast(
          msg: 'O CPF deve ter no mínimo 11 dígitos',
          toastLength: Toast.LENGTH_LONG);
      return false;
    }

    if (!(await usersController.verifyExistUserByCpf(
        cpf: _cpfController.text))) {
      Fluttertoast.showToast(
        msg: 'Usuário não encontrado!',
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    if (!(await usersController.tryLogin(
      cpf: _cpfController.text,
      password: _passwordController.text,
    ))) {
      Fluttertoast.showToast(
        msg: 'Senha incorreta!',
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
    return true;
  }

  String? _fieldValidator(value) {
    return (value == null || value.isEmpty) ? 'Campo obrigatório!' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: SvgPicture.asset(
                      'assets/images/svg/jagua_logo_cmyk.svg',
                      width: 180,
                      height: 180,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _cpfController,
                        hintText: "CPF",
                        validator: _fieldValidator,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 11,
                      ),
                      PasswordFormField(
                        // key: Keys.signInPasswordField,
                        controller: _passwordController,
                        hintText: "Senha",
                        validator: _fieldValidator,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: PrimaryButton(
                    text: 'Logar',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _tryLogin();
                      }
                    },
                  ),
                ),
                MultiTextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SignUpPage(),
                      ),
                    );
                  },
                  children: [
                    Text(
                      'Ainda não possui uma conta? ',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade500),
                    ),
                    Text(
                      'Clique aqui',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade900),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
