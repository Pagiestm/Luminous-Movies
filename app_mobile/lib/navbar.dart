import 'package:flutter/material.dart';
import 'dart:ui';
import 'pages/page1.dart';
import 'pages/Page2.dart';
import 'pages/Page3.dart';
import 'pages/Page4.dart';
import 'pages/Page5.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.white),
                      label: 'Accueil',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.white),
                      label: 'Ma liste',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business, color: Colors.white),
                      label: 'Découvrir',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school, color: Colors.white),
                      label: 'Rechercher',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school, color: Colors.white),
                      label: 'Profil',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
