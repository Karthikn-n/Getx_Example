import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_state/controllers/user_controller.dart';

class HomeScreen extends GetView<UserController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          IconButton(
            onPressed: controller.getUsers, 
            icon: Icon(Icons.refresh)
          )
        ],
      ),
      body: Obx(() {
        final users = controller.users;
        if(users.isEmpty) {
          return Center(
            child: Text("User not found"),
          );
        }
        return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return InkWell(
            // splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              
            },
            child: ListTile(
              dense: true,
              title: Text(users[index].name),
              subtitle: Text(users[index].email),
              trailing: IconButton(
                onPressed: () => controller.deleteUser(users[index].id ?? 0), 
                icon: Icon(Icons.delete)
              ),
            ),
          );
        },
      );
      },),
    );
  }
}