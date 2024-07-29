import 'package:flutter/material.dart';
import 'package:food_recommend_fontend/api_service.dart';
import 'package:food_recommend_fontend/screens/menu_detail_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  final String restaurantName;

  RestaurantListScreen({required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ລາຍການອາຫານ - $restaurantName',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 169, 40),
      ),
      body: FutureBuilder<List<dynamic>>(
        future:
            ApiService.fetchRestaurantData('restaurantMenu', restaurantName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No menu found for this restaurant'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                var imageUrl =
                    'images/${item['ລາຍການອາຫານ']}.jpg'; // ใช้ชื่อไฟล์ภาพตามชื่อรายการอาหาร
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['ລາຍການອາຫານ'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: ${item['ລາຄາ']} ກີບ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuDetailScreen(
                            foodName: item['ລາຍການອາຫານ'],
                            restaurantName: restaurantName, // ส่งชื่อร้านไปด้วย
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
