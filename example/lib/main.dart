import 'package:flutter/material.dart';
import 'package:animated_onboarding/animated_onboarding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pages = [
    OnboardingPage(child: Text("Title1", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xffff1744)),
    OnboardingPage(child: Text("Title2", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xffff9100)),
    OnboardingPage(child: Text("Title3", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xff00695c)),
    OnboardingPage(child: Text("Title4", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xff5c6bc0)),
    OnboardingPage(child: Text("Title5", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xff37474f)),
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedOnboarding(
      pages: _pages,
      pageController: PageController(),
      onFinishedButtonTap: () {
        print("FINISHED!!");
      },
      topLeftChild: Text(
        "App Name",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      topRightChild: FlatButton(
        child: Text(
          "Skip",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }
}
