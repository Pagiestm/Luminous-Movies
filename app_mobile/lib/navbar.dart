import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import './services/navigation.dart';
import 'pages/Accueil.dart';
import 'pages/Decouvrir.dart';
import 'pages/MaListe.dart';
import 'pages/Profil.dart';
import 'pages/Rechercher.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  Navigation navigation = Navigation.getInstance();

  static const List<Widget> _widgetOptions = <Widget>[
    Accueil(),
    MaListe(),
    Decouvrir(),
    Rechercher(),
    Profil(),
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
              filter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  selectedFontSize: 12,
                  selectedLabelStyle: GoogleFonts.sora(),
                  unselectedFontSize: 10,
                  unselectedLabelStyle: GoogleFonts.sora(),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/home.svg",
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          )),
                      activeIcon: Material(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          "assets/icons/home-fill.svg",
                          width: 24,
                          height: 24,
                          color: Colors.red.shade900,
                        ),
                      ),
                      label: "Accueil",
                    ),
                    BottomNavigationBarItem(
                      icon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/heart.svg",
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          )),
                      activeIcon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/heart-fill.svg",
                            width: 24,
                            height: 24,
                            color: Colors.red.shade900,
                          )),
                      label: 'Ma liste',
                    ),
                    BottomNavigationBarItem(
                      icon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/compass.svg",
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          )),
                      activeIcon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/compass-fill.svg",
                            width: 24,
                            height: 24,
                            color: Colors.red.shade900,
                          )),
                      label: 'Découvrir',
                    ),
                    BottomNavigationBarItem(
                      icon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/magnifying-glass.svg",
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          )),
                      activeIcon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/magnifying-glass-fill.svg",
                            width: 24,
                            height: 24,
                            color: Colors.red.shade900,
                          )),
                      label: 'Rechercher',
                    ),
                    BottomNavigationBarItem(
                      icon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/user.svg",
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          )),
                      activeIcon: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/user-fill.svg",
                            width: 24,
                            height: 24,
                            color: Colors.red.shade900,
                          )),
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
            )),
          ),
        ],
      ),
    );
  }
}
