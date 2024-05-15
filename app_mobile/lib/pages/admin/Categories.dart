import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  CategoriesState createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                title: Text('Catégories', style: GoogleFonts.getFont('Sora')),
                backgroundColor: Colors.black,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_sharp),
                    onPressed: () {
                      _addCategory(context);
                    },
                  ),
                ]
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
          // Ici, vous pouvez ajouter le code pour afficher les catégories
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState){
            return Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text('Ajouter une catégorie'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: nameController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Nom de la catégorie",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]
                  ),
                ),
              )
            );
          }
        );
      },
    );
  }
}