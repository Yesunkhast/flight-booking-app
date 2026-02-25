import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/widgets/app_button/back_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:flight_app/widgets/user/auth_wrap.dart';
import 'package:flight_app/widgets/user/login_form.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        leading: BackIconButton(onTap: () {
          Get.back();
        }),
        actions: [
          TextButton(
            onPressed: () {
            Get.toNamed(AppLink.register);
          },
            child: const Row(
              children: [
                Text('REGISTER', style: TextStyle(color: Colors.white)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: Colors.white)
              ],
            )
          )
        ],
      ),
      body: const AuthWrap(content: LoginForm())
    );
  }
}