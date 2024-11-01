import 'package:dailyapp/month_schedule/edit_month_schedule.dart/edit_month_schedule_View.dart';
import 'package:dailyapp/screen/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'methods/local_push_notifications.dart';
import 'methods/message_page.dart';
import 'month_schedule/month_schedule_View.dart';

//푸시 알림 터치시 응답 처리용 경로
final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //로컬 푸시 알림 초기화
  await LocalPushNotifications.init();

  //앱이 종료된 상태에서 푸시 알림을 탭할 때
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/message',
          arguments: notificationAppLaunchDetails?.notificationResponse?.payload);
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
        routes: {
          '/': (context) => const Intro(),
          '/message': (context) => const MessagePage(),
          '/MonthScheduleView' : (context) => MonthScheduleView()
        },
      //home: Intro()
    );
  }
}