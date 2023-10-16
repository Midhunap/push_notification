import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_project_task/main.dart';
import 'package:flutter_project_task/views/notification_screen.dart';


// Future<void> handleBackgroundMessage(RemoteMessage message)async{
//
//   print('Title:${message.notification?.title}');
//   print('Body:${message.notification?.body}');
//   print('Payload:${message.data}');
//
// }
//
// void handleMessage(RemoteMessage? message){
//   if(message == null ) return;
//   navigatorKey.currentState?.pushNamed(
//     NotificationScreen.route,
//     arguments: message,
//   );
// }
//
// Future initPushNotifications()async{
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
// }
//
// class FirebaseApi{
//
//   final _firebaseMessaging = FirebaseMessaging.instance; //instance for firebase messaging
//
//   Future<void> initNotification()async{ //
//     await _firebaseMessaging.requestPermission(); //request permission from the user
//     final fCMToken = await _firebaseMessaging.getToken(); //generate a token
//     print('token :$fCMToken');
//     initPushNotifications();
//
//     //receive notification in the background in terminated case
//
//   }
//
// }