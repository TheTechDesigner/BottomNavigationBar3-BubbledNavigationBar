import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFC41A3B),
        primaryColorLight: Color(0xFFFBE0E6),
        accentColor: Color(0xFF1B1F32),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final titles = ['Home', 'Category', 'Search', 'Cart', 'Profile'];
  final colors = [
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.black,
  ];
  final icons = [
    CupertinoIcons.home,
    CupertinoIcons.create,
    CupertinoIcons.search,
    CupertinoIcons.shopping_cart,
    CupertinoIcons.person,
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'BottomNavigationBar (Bubble)';

  MenuPositionController _menuPositionController;
  PageController _pageController;
  bool userPageDrag = false;

  @override
  void initState() {
    super.initState();
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController = PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDrag(ScrollNotification scrollNotification) {
    if(scrollNotification is UserScrollNotification && scrollNotification.direction != ScrollDirection.idle) {
      userPageDrag = true;
    } else if(scrollNotification is ScrollEndNotification) {
      userPageDrag = false;
    }
    if(userPageDrag) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          checkUserDrag(scrollNotification);
        },
        child: PageView(
          controller: _pageController,
          children: widget.colors
              .map(
                (Color c) => Container(color: c),
              )
              .toList(),
          onPageChanged: (page) {},
        ),
      ),
      bottomNavigationBar: BubbledNavigationBar(
        controller: _menuPositionController,
        initialIndex: 0,
        itemMargin: EdgeInsets.all(8.0),
        backgroundColor: Colors.white,
        defaultBubbleColor: Colors.red,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: Duration(seconds: 2), curve: Curves.easeInBack);
        },
        items: widget.titles.map((title) {
          var index = widget.titles.indexOf(title);
          var color = widget.colors[index];
          return BubbledNavigationBarItem(
            icon: getIcon(index, color),
            activeIcon: getIcon(index, Colors.white),
            bubbleColor: color,
            title: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        widget.icons[index],
        size: 30.0,
        color: color,
      ),
    );
  }
}
