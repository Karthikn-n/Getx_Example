import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_state/controllers/user_controller.dart';
import 'package:get_state/routes/app_pages.dart';

class Register extends GetView<UserController> {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "chat with AI",
            onPressed: () => Get.toNamed(AppRoutes.chat),
            icon: Icon(Icons.chat)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12.0),
        child: Column(
          spacing: 10,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
              ),
            ),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.registerUser();
              }, 
              child: Text("Register")
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already registered? "),
                TextButton(
                  onPressed: (){
                    Get.offAllNamed(AppRoutes.login);
                  }, 
                  child: Text("login")
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}