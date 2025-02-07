import 'package:asset_manager_test/controllers/users_controller.dart';
import 'package:asset_manager_test/src/common/widgets/buttons/multi_text_button.dart';
import 'package:asset_manager_test/src/common/widgets/buttons/primary_button.dart';
import 'package:asset_manager_test/src/common/widgets/fields/custom_text_form_field.dart';
import 'package:asset_manager_test/src/common/widgets/fields/password_form_field.dart';
import 'package:asset_manager_test/views/pages/sign_in_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UsersController usersController = UsersController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _tryRegister() async {
    if (_cpfController.text.length < 11) {
      Fluttertoast.showToast(
          msg: 'O CPF deve ter no mínimo 11 dígitos',
          toastLength: Toast.LENGTH_LONG);
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: 'Senhas diferentes!',
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    if (await usersController.verifyExistUserByCpf(cpf: _cpfController.text)) {
      Fluttertoast.showToast(
        msg: 'Usuário já cadastrado!',
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    if (await usersController.registerUser(
      name: _nameController.text,
      cpf: _cpfController.text,
      password: _passwordController.text,
    )) {
      Fluttertoast.showToast(
        msg: 'Usuário cadastrado com sucesso!',
        toastLength: Toast.LENGTH_LONG,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const SignInPage(),
        ),
      );

      return true;
    }

    Fluttertoast.showToast(
      msg: 'Erro ao cadastrar usuário!',
      toastLength: Toast.LENGTH_LONG,
    );

    return false;
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
                    'Cadastro',
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
                        controller: _nameController,
                        hintText: "Nome",
                        validator: _fieldValidator,
                      ),
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
                        controller: _passwordController,
                        hintText: "Senha",
                        validator: _fieldValidator,
                      ),
                      PasswordFormField(
                        controller: _confirmPasswordController,
                        hintText: "Confirme sua senha",
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
                    text: 'Cadastrar',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _tryRegister();
                      }
                    },
                  ),
                ),
                MultiTextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SignInPage(),
                      ),
                    );
                  },
                  children: [
                    Text(
                      'Já possui uma conta? ',
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
