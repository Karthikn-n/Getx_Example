import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:get_state/controllers/user_controller.dart';
import 'package:get_state/routes/app_pages.dart';

class LoginScreen extends GetView<UserController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            ElevatedButton(
              onPressed: controller.login, 
              child: Text("Login")
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Have an account? "),
                TextButton(
                  onPressed: (){
                    Get.offAllNamed(AppRoutes.REGISTER);
                  }, 
                  child: Text("Register")
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}