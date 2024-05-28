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
    fetchCategories();
  }

  void fetchCategories() async {
    var fetchCategories = await CategoriesService().fetchCategories();
    setState(() {
      categories = fetchCategories;
    });
  }

  Future<void> createCategory(String name) async {
    try {
      var newCategory = await CategoriesService().createCategory(name);
      setState(() {
        categories.add(newCategory);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur est survenue lors de la création de la catégorie: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          Expanded(
            child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: categories.isEmpty
              ? CircularProgressIndicator()
              : ListView.builder(
                padding: EdgeInsets.only(bottom: 100),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(categories[index].name),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Modifier'),
                              onPressed: () {
                                // TODO: Implement modification logic
                              },
                            ),
                            TextButton(
                              child: const Text('Supprimer'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Êtes-vous sûr de vouloir supprimer ${categories[index].name} ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Annuler'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Supprimer'),
                                          onPressed: () {
                                            CategoriesService()
                                                .deleteCategory(
                                                    categories[index].id)
                                                .then((_) {
                                              setState(() {
                                                categories.removeWhere(
                                                    (element) =>
                                                        element.id ==
                                                        categories[index]
                                                            .id);
                                              });
                                              Navigator.of(context).pop();
                                            }).catchError((e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Une erreur est survenue lors de la suppression de la catégorie: $e'),
                                                  backgroundColor:
                                                      Colors.red,
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une catégorie'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  createCategory(nameController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
