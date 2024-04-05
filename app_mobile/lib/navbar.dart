import 'package:flutter/material.dart';
import 'dart:ui';
import 'pages/Accueil.dart';
import 'pages/MaListe.dart';
import 'pages/Decouvrir.dart';
import 'pages/Rechercher.dart';
import 'pages/Profil.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Accueil(),
    MaListe(),
    Decouvrir(),
    Rechercher(),
    Profil(),
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
                      icon: Icon(Icons.home),
                      label: 'Accueil',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border),
                      label: 'Ma liste',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore),
                      label: 'Découvrir',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'Rechercher',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profil',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.red.shade900,
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
