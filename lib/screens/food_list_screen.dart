import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_recommend_fontend/api_service.dart';
import 'package:food_recommend_fontend/ip.dart';
import 'menu_detail_screen.dart';

class FoodListScreen extends StatelessWidget {
  final List<String> selectedCategories;

  FoodListScreen({required this.selectedCategories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 255, 169, 40),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food List',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              selectedCategories.join(', '),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.fetchData(
            'sheet1', {'categories': selectedCategories.join(',')}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            // Sorting data by rating in descending order
            List<dynamic> sortedData = snapshot.data!;
            sortedData.sort((a, b) => b['ຄະແນນ'].compareTo(a['ຄະແນນ']));

            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: sortedData.length,
              itemBuilder: (context, index) {
                var item = sortedData[index];
                String restaurantName = '';

                item.forEach((key, value) {
                  if (value == 1 &&
                      key.startsWith('ຮ້ານ') &&
                      restaurantName.isEmpty) {
                    restaurantName = key;
                  }
                });

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl:
                            'http://${AppConfig.ip}:3000${item['imageUrl']}',
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                        SizedBox(height: 5),
                        Text(
                          'Restaurant: $restaurantName',
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
                            restaurantName: restaurantName ?? 'Unknown Restaurant',
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


