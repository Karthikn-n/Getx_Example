import 'package:get/get.dart';
import 'package:get_state/controllers/user_controller.dart';

class AllBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
  }
  
}