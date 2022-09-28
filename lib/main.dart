import 'package:flutter/material.dart';
import 'package:lix/locator.dart';
import 'package:lix/models/user.dart';
import 'package:lix/screens/views/dashboard.dart';
import 'package:lix/screens/views/intro_slider.dart';
// import 'package:lix/services/auth.dart';
import 'package:lix/services/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  HelperService helperService = locator<HelperService>();
  await helperService.initialize();
  User? user = await locator<HelperService>().retrievingUserDetails();
  runApp(MyApp(
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({
    Key? key,
    this.user,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lix',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Lix', user: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final User? user;
  const MyHomePage({
    Key? key,
    required this.title,
    required this.user,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.user != null ? const Dashboard() : const IntroSlider(),
      theme: ThemeData(fontFamily: 'Inter'),
    );
  }
}
