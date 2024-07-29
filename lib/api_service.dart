import 'dart:convert';
import 'package:food_recommend_fontend/ip.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://${AppConfig.ip}:3000/api';

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
    final uri = Uri.parse('$baseUrl/foodDetail')
        .replace(queryParameters: {'foodName': foodName});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No details found');
    }
  }

  static Future<List<dynamic>> fetchRestaurantData(
      String sheet, String restaurantName) async {
    final uri = Uri.parse('$baseUrl/$sheet')
        .replace(queryParameters: {'restaurantName': restaurantName});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('fetchRestaurantData response: ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<http.Response> register(String firstName, String gender,
      String age, String email, String password) {
    return http.post(
      Uri.parse('http://${AppConfig.ip}:3000/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'gender': gender,
        'age': age,
        'email': email,
        'password': password,
      }),
    );
  }

  static Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
