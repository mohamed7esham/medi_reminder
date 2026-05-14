import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/services/notification_service.dart';
// import 'package:medi_reminder/presentation/onBoarding/onBoarding.dart';
import 'presentation/Home/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  final status = await Permission.notification.request();

  debugPrint("🔔 Notification permission: $status");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await NotificationService.init();
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  runApp(BlocProvider(create: (_) => MedicineCubit(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Use your design's width and height
      minTextAdapt: true,
      splitScreenMode: true, // Enable split screen mode
      builder: (context, child) {
        return MaterialApp(
          // navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: Homescreen(),
        );
      },
    );
  }
}
