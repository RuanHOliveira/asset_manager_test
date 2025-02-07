import 'package:asset_manager_test/views/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 4),
          onEnd: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SignInPage(),
              ),
            );
          },
          child: SvgPicture.asset(
            'assets/images/svg/jagua_logo_cmyk.svg',
            width: 170,
            height: 170,
          ),
        ),
      ),
    );
  }
}
