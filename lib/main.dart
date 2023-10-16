import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_task/controllers/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project_task/views/home_screen.dart';
import 'firebase_options.dart';



Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

// class Notification extends StatefulWidget {
//   const Notification({super.key});
//
//   @override
//   State<Notification> createState() => _NotificationState();
// }
//
// class _NotificationState extends State<Notification> {
//
//   late FirebaseNotification firebase;
//   String? notificationTitle;
//   String? notificationBody;
//
//   handleAsync()async{
//     String? token = await firebase.getToken();
//     print("token$token");
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     firebase =FirebaseNotification();
//     firebase.initialize();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final notification = message.notification;
//       if (notification != null) {
//         setState(() {
//           notificationTitle = notification.title;
//           notificationBody = notification.body;
//         });
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//         children: [
//           Text('Hello'),
//           if(notificationTitle != null && notificationBody != null)
//             Column(
//               children: [
//                 Text('Notification Title: $notificationTitle'),
//                 Text('Notification Body: $notificationBody'),
//               ],
//             ),
//         ],
//       ),),
//     );
//   }
// }

