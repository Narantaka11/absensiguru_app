import 'package:get/get.dart';

class DashboardController extends GetxController {
  var index = 0.obs;

  void changeTab(int i) {
    index.value = i;
  }
}
