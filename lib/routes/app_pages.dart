import 'package:get/get.dart';
import 'package:get_state/bindings/bindings.dart';
import 'package:get_state/screens/chat_screen.dart';
import 'package:get_state/screens/home_screen.dart';
import 'package:get_state/screens/login_screen.dart';
import 'package:get_state/screens/register.dart';

part 'routes.dart';

class AppPages {
  static final Bindings bindings = AllBindings();
  static final routes = [
    GetPage(
      name: AppRoutes.register, 
      page: () => Register(), 
      binding: bindings
    ),
    GetPage(
      name: AppRoutes.home, 
      page: () => HomeScreen(),
      binding: bindings
    ),
    GetPage(
      name: AppRoutes.login, 
      page: () => LoginScreen(),
      binding: bindings
    ),
    GetPage(
      name: AppRoutes.chat, 
      page: () => ChatScreen(),
      binding: bindings
    ),
    
  ];
}