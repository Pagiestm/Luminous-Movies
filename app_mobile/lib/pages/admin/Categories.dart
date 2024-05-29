import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elegant_notification/elegant_notification.dart';
import '../../services/categories/categories.dart';
import '../../models/categories.dart';
import '../../components/AddUpdateCategoryModal.dart';

class CategoriesAdmin extends StatefulWidget {
  const CategoriesAdmin({super.key});

  @override
  CategoriesState createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<CategoriesAdmin> {
  bool isLoading = false;
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

  void showAddUpdateCategoryModal({Categories? category}) {
    showDialog(
      context: context,
      builder: (context) => AddUpdateCategoryModal(
        updatingCategory: category,
        onCategoryUpdated: fetchCategories, // Pass the callback
      ),
    );
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
                    onPressed: () => showAddUpdateCategoryModal(),
                  ),
                ],
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
          Expanded(
            child: Container(
              child: categories.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        var categoriesReversed = categories.reversed.toList();
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.category),
                                title: Text(categoriesReversed[index].name),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Modifier'),
                                    onPressed: () async {
                                      showAddUpdateCategoryModal(
                                        category: categoriesReversed[index],
                                      );
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
                                                'Êtes-vous sûr de vouloir supprimer la catégorie ${categoriesReversed[index].name} ?'),
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
                                                          categoriesReversed[
                                                                  index]
                                                              .id)
                                                      .then((_) {
                                                    setState(() {
                                                      categories.removeWhere(
                                                          (element) =>
                                                              element.id ==
                                                              categoriesReversed[
                                                                      index]
                                                                  .id);
                                                    });
                                                    Navigator.of(context).pop();

                                                    // Afficher une notification élégante
                                                    ElegantNotification.success(
                                                      title: Text(
                                                          "Catégorie supprimée",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      description: Text(
                                                          '${categoriesReversed[index].name} a été supprimée avec succès.',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ).show(context);
                                                  }).catchError((e) {
                                                    ScaffoldMessenger.of(
                                                            context)
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
            ),
          ),
        ],
      ),
    );
  }
}
