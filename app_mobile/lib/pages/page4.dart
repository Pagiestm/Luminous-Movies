import 'package:flutter/material.dart';

void main() => runApp(const SearchBarApp());

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({Key? key}) : super(key: key);

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title:
              const Text('Rechercher', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFF444444), // Set background color
                borderRadius: BorderRadius.circular(18.0), // Set border radius
              ),
              child: TextField(
                cursorColor: Colors.white, // Set cursor color to white
                decoration: InputDecoration(
                  hintText:
                      'Rechercher un film ou une catégorie', // Set hint text
                  suffixIcon: const Icon(Icons.search),
                  border:
                      InputBorder.none, // Remove default underline decoration
                ),
                style: TextStyle(
                    color: Color(0xFFAAAAAA)), // Set text color to #AAAAAA
              ),
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
            return [];
          }),
        ),
      ),
    );
  }
}
