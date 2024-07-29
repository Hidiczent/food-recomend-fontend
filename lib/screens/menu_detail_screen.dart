import 'package:flutter/material.dart';
import 'package:food_recommend_fontend/api_service.dart';
import 'package:food_recommend_fontend/screens/restaurant_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDetailScreen extends StatelessWidget {
  final String foodName;
  final String restaurantName;

  MenuDetailScreen({required this.foodName, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Menu Detail',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 169, 40),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchFoodDetail(foodName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No details found'));
          } else {
            var item = snapshot.data!;
            var imageUrl = 'images/${foodName}.jpg'; // ใช้ภาพจาก assets
            var restaurantDetails = item['restaurantDetails'];
            String? firstRestaurantMapLink;

            if (restaurantDetails != null && restaurantDetails.isNotEmpty) {
              var restaurant = restaurantDetails.firstWhere(
                (element) => element['restaurant'] == restaurantName,
                orElse: () => null,
              );
              firstRestaurantMapLink =
                  restaurant != null ? restaurant['maplink'] : null;
            }

            // Debug output
            print('Data received: $item');

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error loading image: $error');
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    item['ລາຍການອາຫານ'] ?? 'Unknown Food',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ລາຄາ: ${item['ລາຄາ'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   'ຮ້ານອາຫານ: $restaurantName',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(restaurantName ?? 'Unknown Restaurant'),
                    subtitle: Row(
                      children: [
                        SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (firstRestaurantMapLink != null) {
                                _launchURL(firstRestaurantMapLink!);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.location_pin, color: Colors.red),
                                SizedBox(width: 5),
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'ຮ້ານອາຫານທີ່ແນະນຳ:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (restaurantDetails != null && restaurantDetails is List)
                    ...restaurantDetails.map<Widget>((restaurant) {
                      return Card(
                        child: ListTile(
                          title: Text(
                              restaurant['restaurant'] ?? 'Unknown Restaurant'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ທີ່ຢູ່: ${restaurant['address'] ?? 'N/A'}'),
                              SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(restaurant['maplink'] ?? '');
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Open in Maps',
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantListScreen(
                                              restaurantName:
                                                  restaurant['restaurant'] ??
                                                      'Unknown Restaurant'),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.more_horiz,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'View Menu',
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
