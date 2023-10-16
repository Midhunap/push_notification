import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_task/consts/colors.dart';
import 'package:http/http.dart' as http;
import '../consts/colors.dart';
import '../controllers/push_notification.dart';
import '../models/product_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProductElement> products = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  int skip = 0;
  int limit = 10;

  //notification
  late FirebaseNotification firebase;
  String? notificationTitle;
  String? notificationBody;

  handleAsync()async{
    String? token = await firebase.getToken();
    print("token$token");
  }

  @override
  void initState() {
    super.initState();
    firebase =FirebaseNotification();
    firebase.initialize();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        setState(() {
          notificationTitle = notification.title;
          notificationBody = notification.body;
        });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;

      if (notification != null) {
        setState(() {
          notificationTitle = notification.title;
          notificationBody = notification.body;
        });


        if(notificationTitle != null && notificationBody != null){
          showDialog(context: context, builder: (context){
            return AlertDialog(

              backgroundColor: backgroundColor.withOpacity(0.8),
              title: Text(notificationTitle!,textAlign: TextAlign.center,style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.redAccent,),),
              content: Text(notificationBody!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.white),),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.5),
                    minimumSize: const Size(80, 35),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12), // Rounded edges
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            );
          });

        }

      }

    });
  }


  Future<bool> getProductData({bool isRefresh = false}) async {
    if (isRefresh) {
      //refresh true only to get new updated data
      skip = 0;
      limit = 10;
    } else {
      if (skip >= limit) {
        refreshController.loadNoData();
        return false;
      }
    }

    final url = 'https://dummyjson.com/products?skip=$skip&limit=$limit';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final result = productFromJson(response.body);

      if (isRefresh) {
        products = result.products;
      } else {
        products.addAll(result.products);
      }
      skip = skip + limit;
      limit = skip + 10;
      setState(() {
        //6+6 =12
      });
      return true;
    } else {
      return false;
    }
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(fit: StackFit.expand, children: <Widget>[
            Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              color: backgroundColor
                  .withOpacity(0.6), // Adjust the opacity and color as needed
            ),
            Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(150),
                child: AppBar(
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/hibye.jpg',
                          scale: .8,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(120, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded edges
                            ),
                          ),
                          onPressed: () {
                            print('Notification Title: $notificationTitle');
                            print('Notification Body: $notificationBody');

                          },
                          child: const Text(
                            'Add New',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  bottom: const TabBar(
                    indicatorColor: Colors.red,
                    tabs: [
                      Tab(
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 18, // Custom font size
                            fontWeight: FontWeight.bold, // Custom font weight
                            color: Colors.white, // Custom text color
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'My feeds',
                          style: TextStyle(
                            fontSize: 18, // Custom font size
                            fontWeight: FontWeight.bold, // Custom font weight
                            color: Colors.white, // Custom text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  elevation: 0.1,
                  selectedItemColor: Colors.redAccent,
                  backgroundColor: const Color(0x00ffffff),
                  type: BottomNavigationBarType.fixed,
                  unselectedItemColor: Colors.white,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.sms_outlined,
                        color: Colors.white,
                      ),
                      label: 'feeds',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.sms_outlined,
                        color: Colors.white,
                      ),
                      label: 'Chats',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.widgets_outlined,
                        color: Colors.white,
                      ),
                      label: 'slots',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.event_note_outlined,
                        color: Colors.white,
                      ),
                      label: 'events',
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SmartRefresher(
                  enablePullUp: true,
                  controller: refreshController,
                  onRefresh: () async {
                    final result = await getProductData(isRefresh: true);
                    if (result) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result = await getProductData();
                    if (result) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 15.0,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final product = products[index];
                      String apiDescription =
                          products[index].description.toString();
                      String descriptionWithLineBreaks =
                          '${apiDescription.substring(0, apiDescription.length ~/ 2)}\n${apiDescription.substring(apiDescription.length ~/ 2)}';
                      return Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: Image.network(
                                product.thumbnail,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Image.asset(
                                'assets/logo.jpg',
                              ),
                            ),
                            Positioned(
                              top: 220,
                              left: 12,
                              child: Text(
                                product.brand,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 12,
                              child: Text(
                                product.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 60,
                              child: Text(
                                product.category,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.5), // Transparent black color
                                  shape: BoxShape.circle,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              top: 278,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    descriptionWithLineBreaks,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Price : ${product.price} \$",
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              left: 12,
                              top: 350,
                              child: Row(
                                children:  [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(Icons.thumb_up_alt_outlined,
                                      size: 30, color: Colors.white),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '12.4k',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Icon(Icons.sms_outlined,
                                      size: 30, color: Colors.white),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '12.4k',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Icon(Icons.reply_all_outlined,
                                      size: 30, color: Colors.white),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '12.4k',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}


