import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:strecording/pages/welcome_screen.dart';
import 'package:strecording/pages/home_page.dart';
import 'package:strecording/pages/diary_page.dart';
import 'package:strecording/pages/setting_page.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'a8a1d140843f9fde9e271aaba4a1412b');
  initializeDateFormatting().then((_) => runApp(MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STREcording',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'NanumGothic',
      ),
      home: const WelcomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.email,
      required this.name,
      required this.profileImg});
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String email;
  final String name;
  final String profileImg;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const DiaryPage(),
    SettingPage(
        email: widget.email, name: widget.name, profileImg: widget.profileImg),
  ];
  void _onItemTapped(int index) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3CADAB);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('STREcording'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 26),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset('assets/images/book_clicked.png',
                    width: 26, height: 26)
                : Image.asset('assets/images/book_unclicked.png',
                    width: 26, height: 26),
            label: 'Diary',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
