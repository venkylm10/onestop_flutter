import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/material.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:shared_preferences/shared_preferences.dart';

// Timer? timer;
//
// @pragma('vm:entry-point')
// void firewallNotificationTap(NotificationResponse details) async {
//   if (details.actionId == "connect") {
//     final auth = FirewallAuth();
//     await auth.login();
//     timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       Logger().i("Sending keep-alive request...");
//       await auth.refreshSession();
//     });
//   } else if (details.actionId == "disconnect") {
//     final auth = FirewallAuth();
//     await auth.logout();
//     timer?.cancel();
//   }
// }
//
// Future<void> showPersistentNotification() async {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'firewall_notification_channel', // id
//     'Firewall Notification Channel', // title
//     description: 'Firewall Notification Channel',
//     importance: Importance.max,
//   );
//
//   AndroidInitializationSettings initializationSettingsAndroid =
//       const AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: firewallNotificationTap);
//
//   AndroidNotificationDetails androidNotificationDetails =
//       const AndroidNotificationDetails(
//     "firewall_notification_channel",
//     "Firewall Notification Channel",
//     channelDescription: "Firewall Notification Channel",
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: 'notification_icon',
//     ongoing: true,
//     autoCancel: false,
//     actions: <AndroidNotificationAction>[
//       AndroidNotificationAction(
//         'connect',
//         'Connect',
//         showsUserInterface: false,
//         cancelNotification: false,
//         icon: null,
//       ),
//       AndroidNotificationAction(
//         'disconnect',
//         'Disconnect',
//         showsUserInterface: false,
//         cancelNotification: false,
//         icon: null,
//       ),
//     ],
//   );
//   NotificationDetails notificationDetails = NotificationDetails(
//     android: androidNotificationDetails,
//   );
//
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     "IITG Network Login",
//     "Hello",
//     notificationDetails,
//   );
// }

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          playSound: true,
          icon: 'notification_icon');
  DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );
  RemoteNotification? notification = message.notification;

  print("Notification : $notification");
  if (checkNotificationCategory(message.data['category'])) {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      message.data['body'],
      notificationDetails,
    );
  }
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    print('notification payload: $payload');
  }
  // await Navigator.pushNamed(context, HomePage.id);
}

bool checkNotificationCategory(String type) {
  debugPrint("Notification type: $type");
  switch (type) {
    case "announcement":
    case "lost":
    case "found":
    case "buy":
    case "sell":
    case "cabSharing":
    case "swc":
    case "irbs":
      return true;
  }
  return false;
}

Future<bool> checkForNotifications() async {
  await FirebaseMessaging.instance.subscribeToTopic('all');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          playSound: true,
          icon: 'notification_icon');
  DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("Here me");
    print("Message is ${message.data}");
    if (checkNotificationCategory(message.data['category'])) {
      print("apple");
      await flutterLocalNotificationsPlugin.show(message.hashCode,
          message.data['title'], message.data['body'], notificationDetails);
    } else {
      print("ball");
    }
  });

  // Resave list of notifications in case it's initialized to null
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  List<String> notifications = preferences.getStringList('notifications') ?? [];
  preferences.setStringList('notifications', notifications);
  return true;
}
