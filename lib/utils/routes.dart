import 'package:get/get.dart';

import '../ui/pages/home/home_screen.dart';
import '../ui/root_screen.dart';

abstract class Routes {
  static const root = '/root';
  static const home = '/home';
}

class AppPages {
  static final routes = [
    GetPage(
        name: Routes.root,
        page: () => const RootScreen(),
        binding: RootBinding(),
        transition: Transition.noTransition),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
