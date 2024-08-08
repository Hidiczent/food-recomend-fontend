import 'package:flutter/material.dart';
import 'package:food_recommend_fontend/LoginRegister/login_screen.dart';
import 'package:food_recommend_fontend/LoginRegister/register_screen.dart';
import 'package:food_recommend_fontend/provider/category_provider.dart';
import 'package:food_recommend_fontend/screens/Homepage.dart';
import 'package:food_recommend_fontend/screens/Profile.dart';
import 'package:food_recommend_fontend/screens/category_screens.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recommend',
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) =>
            MainPage(token: 'your_token_here'), // ส่ง token ตรงนี้
      },
    );
  }
}

class MainPage extends StatefulWidget {
  final String token; // เพิ่ม token ตรงนี้

  MainPage({required this.token});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Homepage(token: widget.token), // ส่ง token ไปยัง Homepage
      CategoryScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize), label: "Custom"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: Color.fromARGB(255, 255, 169, 40),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
