import 'dart:async';
import 'dart:math';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram/bussiness_logic/add_post/add_post_cubit.dart';
import 'package:instagram/bussiness_logic/chatting/chatting_cubit.dart';
import 'package:instagram/bussiness_logic/get_users/get_users_cubit.dart';
import 'package:instagram/bussiness_logic/login/login_cubit.dart';
import 'package:instagram/bussiness_logic/myShared.dart';
import 'package:instagram/bussiness_logic/show_posts/show_posts_cubit.dart';
import 'package:instagram/ui/home.dart';
import 'package:instagram/ui/login.dart';
import 'package:instagram/ui/maps_screen.dart';
import 'package:instagram/ui/register.dart';
import 'package:instagram/ui/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'bussiness_logic/comment/comment_cubit.dart';
import 'bussiness_logic/register/register_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyShared.init();
  await Firebase.initializeApp();
  runApp(DevicePreview(
    enabled: kDebugMode,
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotifications(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print('Message data: ${message.notification!.body}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      displayNotification();
    });
    // Timer.periodic(Duration(seconds: 2), (timer){
    //   displayNotification();
    // });
  }
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) => print('FCM token ${value.toString()}'));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => AddPostCubit(),
        ),
        BlocProvider(
          create: (context) => ShowPostsCubit(),
        ),
        BlocProvider(
          create: (context) => CommentCubit(),
        ),
        BlocProvider(
          create: (context) => GetUsersCubit(),
        ),
        BlocProvider(
          create: (context) => ChattingCubit(),
        ),

      ],
      child: MaterialApp(

        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        home: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return LoginScreen();
          },
        ),

      ),
    );
  }

  void initNotifications(context)async{
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification:(id, title, body, payload) {} ,);

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification:  (payload) async{
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          await Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => LoginScreen()),
          );
        });
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void displayNotification()async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        Random(100).nextInt(100), 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}
