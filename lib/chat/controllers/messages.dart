import 'package:get/state_manager.dart';

class Messages extends GetxController {
  static Messages? _inst;
  Messages._internal();
  static Messages get inst{
    _inst??=Messages._internal();
    return _inst!;
  }

  
}