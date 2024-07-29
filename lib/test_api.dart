import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.56.89:3000/api';

  static Future<List<dynamic>> fetchData(
      String sheet, Map<String, String> params) async {
    final uri = Uri.parse('$baseUrl/$sheet').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> fetchFoodDetail(String foodName) async {
    final uri = Uri.parse('$baseUrl/foodDetail').replace(queryParameters: {
      'foodName': foodName,
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No details found');
    }
  }

  static Future<List<dynamic>> fetchRestaurantData(
      String sheet, String restaurantName) async {
    final uri = Uri.parse('$baseUrl/$sheet').replace(queryParameters: {
      'restaurantName': restaurantName,
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() async {
  // ทดสอบ fetchData
  try {
    var data = await ApiService.fetchData('sheet1', {'param1': 'value1'}); // ต้องเปลี่ยนเป็นพารามิเตอร์ที่ถูกต้อง
    print('fetchData result: $data');
  } catch (e) {
    print('fetchData error: $e');
  }

  // ทดสอบ fetchFoodDetail
  try {
    var foodDetail = await ApiService.fetchFoodDetail('exampleFoodName'); // ต้องเปลี่ยนเป็นชื่ออาหารที่มีอยู่จริง
    print('fetchFoodDetail result: $foodDetail');
  } catch (e) {
    print('fetchFoodDetail error: $e');
  }

  // ทดสอบ fetchRestaurantData
  try {
    var restaurantData = await ApiService.fetchRestaurantData('sheet2', 'exampleRestaurantName'); // ต้องเปลี่ยนเป็นชื่อร้านที่มีอยู่จริง
    print('fetchRestaurantData result: $restaurantData');
  } catch (e) {
    print('fetchRestaurantData error: $e');
  }
}
