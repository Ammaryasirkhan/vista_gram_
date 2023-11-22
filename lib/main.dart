import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vista_gram_/Layouts/mobile.dart';
import 'package:vista_gram_/Layouts/responsive_widget.dart';
import 'package:vista_gram_/Layouts/web.dart';
import 'package:vista_gram_/Pages/login_page.dart';
import 'package:vista_gram_/Pages/sign_up_page.dart';
import 'package:vista_gram_/Providers/user_provider.dart';
import 'package:vista_gram_/Routes/routes_help.dart';
import 'package:vista_gram_/utils/colors.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.white),
          primarySwatch: const MaterialColor(
            0xFF8DBAAD, // Replace with your desired color value
            <int, Color>{
              50: Color(0xFF8DBAAD),
              100: Color(0xFF8DBAAD),
              200: Color(0xFF8DBAAD),
              300: Color(0xFF8DBAAD),
              400: Color(0xFF8DBAAD),
              500: Color(0xFF8DBAAD),
              600: Color(0xFF8DBAAD),
              700: Color(0xFF8DBAAD),
              800: Color(0xFF8DBAAD),
              900: Color(0xFF8DBAAD),
            },
          ),
          // primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.roboto().fontFamily),
      // home: LoginPage(),
      // home: ResponsiveScreenLayout(
      //     webScreenLayout: WebS(), mobileScreenLayout: MobileS())
      home: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveScreenLayout(
                    webScreenLayout: WebS(), mobileScreenLayout: MobileS());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: ColorRes.app),
              );
            }
            return const LoginPage();
          },
        ),
      ),
      // getPages: Routes.routes,
    );
  }
}
