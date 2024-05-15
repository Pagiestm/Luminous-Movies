import 'package:flutter/material.dart';
import 'dart:ui';
import './services/navigation.dart';
import 'pages/admin/Categories.dart';
import 'pages/admin/Films.dart';

class NavBarAdmin extends StatefulWidget {
  NavBarAdmin({super.key});

  @override
  _NavBarAdminState createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  int _selectedIndex = 0;
  Navigation navigation = Navigation.getInstance();

  static const List<Widget> _widgetOptions = <Widget>[
    CategoriesAdmin(),
    Films(),
  ];

  @override
  void initState() {
    super.initState();
    navigation.selectedIndex().listen((index) {
      if (index >= 0 && index < _widgetOptions.length) {
        setState(() {
          _selectedIndex = index;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _widgetOptions.length) {
      navigation.setIndex(index);
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    navigation.selectedIndex().listen((index) {
      if (index >= 0 && index < 3) {
        setState(() {
          _selectedIndex = index;
        });
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _selectedIndex >= 0 && _selectedIndex < _widgetOptions.length
                ? _widgetOptions.elementAt(_selectedIndex)
                : Container(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.category_outlined),
                      label: 'Catégories',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.movie_creation_outlined),
                      label: 'Films',
                    ),
                  ],
                  currentIndex: _selectedIndex >= 0 && _selectedIndex < 3
                      ? _selectedIndex
                      : 0,
                  selectedItemColor: Colors.red.shade900,
                  unselectedItemColor: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
