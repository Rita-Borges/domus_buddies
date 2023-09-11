import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'User/registo.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentWeather = '';
  String _weatherIconPath = 'assets/Gif/connection-error.gif';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      const apiKey = 'bd5e378503939ddaee76f12ad7a97608';
      const city = 'Lisbon';
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final temp = jsonData['main']['temp'];
        final weatherIconPath = getWeatherIconPath(temp);

        setState(() {
          _currentWeather = 'Temperatura: $temp°C';
          _weatherIconPath = weatherIconPath;
        });
      } else {
        setState(() {
          _currentWeather = 'Failed to fetch weather';
        });
      }
    } catch (e) {
      setState(() {
        _currentWeather = 'Failed to fetch weather';
      });
    }
  }

  String getWeatherIconPath(double temperature) {
    if (temperature >= 30) {
      return 'assets/images/sun_1.png';
    } else if (temperature >= 20 && temperature <= 30) {
      return 'assets/images/sun.png';
    } else if (temperature >= 10 && temperature <= 20) {
      return 'assets/images/sun-behind-cloud.png';
    } else if (temperature >= 5 && temperature <= 10) {
      return 'assets/images/rain.png';
    } else {
      return 'assets/images/snowflake.png';
    }
  }

  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPagev0()),
    );
  }

  void navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue.shade200,
                Colors.blue.shade600,
                Colors.indigo.shade900
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Domus Buddies',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontFamily: 'Handwritten',
                      fontSize: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    _weatherIconPath,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _currentWeather,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Image.asset(
                    'assets/Gif/MV5L.gif',
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: navigateToLoginPage,
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: navigateToRegisterPage,
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Registar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
