import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/splash/splash_screen.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/untils/local_notification_util.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:toastification/toastification.dart';

void main() async {
  await mainApp();
}

Future<void> mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp();
  FirebaseAuth.instanceFor(app: app);
  await LocalNotificationUtil.initialize();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SharedPrefHelper().init();
  runApp(const MyApp());
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  AppUtil.printDebugMode(type: "FCM Token", message: '$fcmToken');
}
void initFirebaseMessagingBackground() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
}

@pragma('vm.entry-point')
Future<void> _firebaseMessagingBackground(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          useMaterial3: true,
          fontFamily: ConstantFont.fontLexendDeca,
          brightness: Brightness.light,
          primaryColorLight: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0.5,
            titleTextStyle: TextStyle(color: Colors.black),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Colors.black.withOpacity(0.3),
            selectionHandleColor: Colors.grey,
          ),
        ),
        home: const SplashScreen(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                },
                child: child,
              ));
        },
      ),
    );
  }
}
