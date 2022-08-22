import 'package:flutter/material.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/intro_slider.dart';
import 'package:lix/services/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  HelperService helperService = locator<HelperService>();
  await helperService.initialize();
  User? user = await locator<HelperService>().retrievingUserDetails();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lix',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Lix'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroSlider(),
      theme: ThemeData(fontFamily: 'Inter'),
    );
  }
}
