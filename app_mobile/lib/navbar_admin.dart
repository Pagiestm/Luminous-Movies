import 'package:flutter/material.dart';
import 'dart:ui';
import './services/navigation.dart';
import 'pages/admin/Categories.dart';
import 'pages/admin/Films.dart';
import 'pages/admin/Deconnexion.dart';

class NavBarAdmin extends StatefulWidget {
  NavBarAdmin({super.key});

  @override
  _NavBarAdminState createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  int _selectedIndex = 0;
  Navigation navigation = Navigation.getInstance();

  static const List<Widget> _widgetOptions = <Widget>[
    Categories(),
    Films(),
    Deconnexion(),
  ];

  void _onItemTapped(int index) {
    navigation.setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    navigation.selectedIndex().listen((index) {
      setState(() {
        _selectedIndex = index;
      });
    });
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
                    BottomNavigationBarItem(
                      icon: Icon(Icons.logout_outlined),
                      label: 'Déconnexion',
                    )
                  ],
                  currentIndex: _selectedIndex,
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
