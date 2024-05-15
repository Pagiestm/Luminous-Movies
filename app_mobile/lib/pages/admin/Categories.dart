import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/categories/categories.dart';
import '../../models/categories.dart';

class CategoriesAdmin extends StatefulWidget {
  const CategoriesAdmin({super.key});

  @override
  CategoriesState createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<CategoriesAdmin> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  List<Categories> categories = [];

  @override
  void initState() {
    super.initState();
  }

  void fetchCategories() async {
    categories = await CategoriesService().fetchCategories();
    setState(() {});
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
                  ]),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: categories.isEmpty
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(categories[index].name),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text('Ajouter une catégorie'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(children: <Widget>[
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
                  ]),
                ),
              ));
        });
      },
    );
  }
}
