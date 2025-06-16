import 'package:get/get.dart';
import 'package:get_state/bindings/bindings.dart';
import 'package:get_state/screens/home_screen.dart';
import 'package:get_state/screens/login_screen.dart';
import 'package:get_state/screens/register.dart';

part 'routes.dart';

class AppPages {
  static final Bindings bindings = AllBindings();
  static final routes = [
    GetPage(
      name: AppRoutes.REGISTER, 
      page: () => Register(), 
      binding: bindings
    ),
    GetPage(
      name: AppRoutes.HOME, 
      page: () => HomeScreen(),
      binding: bindings
    ),
    GetPage(
      name: AppRoutes.LOGIN, 
      page: () => LoginScreen(),
      binding: bindings
    ),
    
  ];
}