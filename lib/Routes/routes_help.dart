import 'package:get/get.dart';

import '../Pages/login_page.dart';
import '../Pages/sign_up_page.dart';

class Routes {
  static const String initialroute = "/";
  static const String famousFood = "/famous-food";
  static const String recommendedFood = "/rec-food";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String home = "/home";

  //Functions For ROUTES
  static String getFamousProducts(int pageId) => '$famousFood? padeId=$pageId';
  static String getInitial() => '$initialroute';
  static String getRecommendedProducts(int pageId) =>
      '$recommendedFood? padeId=$pageId';
  static String loginpage() => '$login';
  static String signuppage() => '$signup';
  static String homepage() => '$home';

  static List<GetPage> routes = [
    // GetPage(
    //   name: initialroute,
    //   page: () {
    //     return MainPage();
    //   },
    //   // transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: home,
    //     page: () {
    //       return HomePage();
    //     },
    //     transition: Transition.fadeIn),
    GetPage(
        name: login,
        page: () {
          return LoginPage();
        },
        transition: Transition.fadeIn),
    GetPage(
        name: signup,
        page: () {
          return SignUPage();
        },
        transition: Transition.fadeIn),
    // GetPage(
    //   name: famousFood,
    //   page: () {
    //     var pageId = Get.parameters['pageId'];
    //     return FoodDetailsPage(
    //         pageId: int.parse(pageId!));
    //   },
    //   //transition: Transition.fadeIn
    // ),
    // GetPage(
    //   name: recommendedFood,
    //   page: () {
    //     var pageId = Get.parameters['pageId'];
    //     return RecFoodDetails(
    //         pageId: int.parse(pageId!));
    //   },
    //   // transition: Transition.fadeIn
    // )
  ];
  //   static const String initialroute = "/";
  //     static const String initialroute = "/";

  // static const String initialroute = "/";
  // static const String initialroute = "/";
  // static const String initialroute = "/";
}
