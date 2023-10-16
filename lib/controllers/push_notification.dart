import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'high_importance_notification',
    description: 'this channel is used for important notification',
    importance: Importance.high,
    playSound: true
);

//notification from firebase ,it will display
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//app in not foreground
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print('a bg message : ${message.messageId}');
  print('${message.data}');
}

class FirebaseNotification{
  initialize()async{
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    var initializationSettingsAndroid =  const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if( notification!= null && android!=null ){

        String title = notification.title ?? '';
        String body = notification.body ?? '';
        print('Received Notification: Title: $title, Body: $body');

        flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body, NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android?.smallIcon,
          )
        ));
      }
    });

  }
  Future<String?> getToken()async{
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    return token;
  }

  subscribeToTopic(String topic)async{
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

}