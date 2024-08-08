import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_recommend_fontend/api_service.dart';
import 'package:food_recommend_fontend/ip.dart';
import 'package:food_recommend_fontend/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'menu_detail_screen.dart';
import 'restaurant_list_screen.dart'; // Import the RestaurantListScreen

class Homepage extends StatefulWidget {
  final String token;
  const Homepage({required this.token});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> _allItems = [];
  List<dynamic> _filteredItems = [];
  List<dynamic> _topRatedRestaurants = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchTopRatedRestaurants();
    _searchController.addListener(() {
      _filterItems(_searchController.text);
    });
  }

  void _fetchData() async {
    try {
      var data = await ApiService.fetchData('sheet1', {});
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final selectedCategories = categoryProvider.selectedCategories;

      // แยกรายการที่ตรงกับหมวดหมู่ที่เลือก
      List<dynamic> selectedItems = data.where((item) {
        return selectedCategories
            .any((category) => item['category'] == category);
      }).toList();

      // แยกรายการที่ไม่ตรงกับหมวดหมู่ที่เลือก
      List<dynamic> otherItems = data.where((item) {
        return !selectedCategories
            .any((category) => item['category'] == category);
      }).toList();

      // สลับรายการที่เลือกไว้กับรายการอื่น
      List<dynamic> combinedItems = [];
      int maxLength = selectedItems.length > otherItems.length
          ? selectedItems.length
          : otherItems.length;
      for (int i = 0; i < maxLength; i++) {
        if (i < selectedItems.length) combinedItems.add(selectedItems[i]);
        if (i < otherItems.length) combinedItems.add(otherItems[i]);
      }

      // สุ่มรายการเพื่อไม่ให้การแสดงผลน่าเบื่อ
      combinedItems.shuffle(Random());

      setState(() {
        _allItems = combinedItems;
        _filteredItems = _allItems;
      });
    } catch (e) {
      // handle error
      print('Failed to load data: $e');
    }
  }

  void _fetchTopRatedRestaurants() async {
    try {
      var topRatedRestaurants = await ApiService.fetchTopRatedRestaurants();
      setState(() {
        _topRatedRestaurants = topRatedRestaurants;
      });
    } catch (e) {
      // handle error
      print('Failed to load top rated restaurants: $e');
    }
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _allItems;
      });
    } else {
      List<dynamic> filtered = _allItems
          .where((item) => item['ລາຍການອາຫານ']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      setState(() {
        _filteredItems = filtered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Disable back button functionality
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 169, 40),
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Find Your Favourite Food',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        body: _allItems.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for Food',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: Icon(Icons.filter_list),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _topRatedRestaurants.map((restaurant) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantListScreen(
                                      restaurantName:
                                          restaurant['restaurantName'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 169, 40),
                              ),
                              child: Text(
                                restaurant['restaurantName'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Found ${_filteredItems.length} items',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          var item = _filteredItems[index];
                          String restaurantName = '';

                          item.forEach((key, value) {
                            if (value == 1 &&
                                key.startsWith('ຮ້ານ') &&
                                restaurantName.isEmpty) {
                              restaurantName = key;
                            }
                          });

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuDetailScreen(
                                    foodName: item['ລາຍການອາຫານ'] ?? 'Unknown',
                                    restaurantName: restaurantName,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'http://${AppConfig.ip}:3000${item['imageUrl']}',
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: double.infinity,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['ລາຍການອາຫານ'] ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${item['ລາຄາ'] ?? ''} ກີບ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 255, 169, 40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
