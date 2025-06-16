import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_state/routes/app_pages.dart';
import 'package:get_state/service/sqflite_service.dart';

class UserController extends GetxController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _db = SqfliteService();
  final RxList<User> users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  void login() async{
    bool isFound = await _db.getUser(emailController.text);
    if(isFound) {
      Get.showSnackbar(
        GetSnackBar(
        message: "loggedIn successfully", 
        margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
        duration: const Duration(seconds: 1),
      ));
      Get.toNamed(AppRoutes.HOME);
    } else {
      Get.showSnackbar(
        GetSnackBar(
        message: "User not found register please", 
        margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
        duration: const Duration(seconds: 1),
      ));
      Get.offAll(AppRoutes.REGISTER);
    }
  }

  void registerUser() async {
    bool registered = await _db.insertUser(User(name: nameController.text, email: emailController.text));
    if(registered) {
      Get.showSnackbar(
        GetSnackBar(
        message: "User registered", 
        margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
        duration: const Duration(seconds: 1),
      ));
      Get.toNamed(AppRoutes.HOME);
    } else {
      Get.showSnackbar(
        GetSnackBar(
        message: "User already registered", 
        margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
        duration: const Duration(seconds: 1),
      ));

    }
  }

  Future<void> getUsers() async {
    users.value = await _db.getUsers();
  }

  Future<void> deleteUser(int id) async {
    bool deleted = await _db.deleteUser(id);
    if (deleted) {
      Get.showSnackbar(GetSnackBar(
        message: "User deleted",
        margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
        duration: const Duration(seconds: 1),
      ));
      getUsers();
      update();
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }
}

class User{
  final int? id;
  final String name;
  final String email;

  User({
    this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(id: json["id"] ?? 0, name: json["name"], email: json["email"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email
    };
  }
}
