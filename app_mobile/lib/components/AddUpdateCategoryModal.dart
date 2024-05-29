import 'package:flutter/material.dart';
import 'package:luminous_movies/models/categories.dart';
import 'package:luminous_movies/services/categories/categories.dart';
import 'package:elegant_notification/elegant_notification.dart';

class AddUpdateCategoryModal extends StatefulWidget {
  final Categories? updatingCategory;
  final VoidCallback onCategoryUpdated; // Add this line

  const AddUpdateCategoryModal({super.key, this.updatingCategory, required this.onCategoryUpdated}); // Add this line

  @override
  AddUpdateCategoryModalState createState() {
    return AddUpdateCategoryModalState();
  }
}

class AddUpdateCategoryModalState extends State<AddUpdateCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingCategory != null) {
      nameController.text = widget.updatingCategory!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.grey[800],
              surfaceTintColor: Colors.transparent,
              title: Text(
                widget.updatingCategory != null ? 'Modifier une catégorie' : 'Ajouter une catégorie',
                textAlign: TextAlign.center,
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Nom de la catégorie",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom de catégorie';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                  ),
                  child: const Text(
                    'Sauvegarder',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);
                      if (widget.updatingCategory != null) {
                        CategoriesService()
                            .updateCategory(
                              widget.updatingCategory!.id,
                              nameController.text,
                            )
                            .then((value) {
                          ElegantNotification.success(
                            title: Text("Modification d'une catégorie",
                                style: TextStyle(color: Colors.black)),
                            description: Text(
                                "La catégorie a été modifiée avec succès",
                                style: TextStyle(color: Colors.black)),
                          ).show(context);
                          widget.onCategoryUpdated(); // Call the callback
                          Navigator.of(context).pop(value);
                        }).catchError((err) => throw err).whenComplete(
                                () => setState(() => isLoading = false));
                      } else {
                        CategoriesService()
                            .addCategory(nameController.text)
                            .then((value) {
                          ElegantNotification.success(
                            title: Text("Ajout d'une catégorie",
                                style: TextStyle(color: Colors.black)),
                            description: Text(
                                "La catégorie a été ajoutée avec succès",
                                style: TextStyle(color: Colors.black)),
                          ).show(context);
                          widget.onCategoryUpdated(); // Call the callback
                          Navigator.of(context).pop(value);
                        }).catchError((err) => throw err).whenComplete(
                                () => setState(() => isLoading = false));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
