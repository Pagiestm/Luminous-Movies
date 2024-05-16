import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:luminous_movies/models/categories.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/services/categories/categories.dart';
import '../services/movies/movies.dart';
import 'package:choice/choice.dart';

class AddUpdateMovieModal extends StatefulWidget {
  final Movie? updatingMovie;
  const AddUpdateMovieModal({super.key, this.updatingMovie});

  @override
  AddMovieModalState createState() {
    return AddMovieModalState();
  }
}

class AddMovieModalState extends State<AddUpdateMovieModal> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();
  TextEditingController actorController = TextEditingController();
  TextEditingController movieLengthController = TextEditingController();
  TextEditingController releaseDateController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  List<String> staring = [];
  List<Categories> choices = [];
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    if (widget.updatingMovie != null) {
      titleController.text = widget.updatingMovie!.title;
      synopsisController.text = widget.updatingMovie!.synopsis;
      movieLengthController.text = widget.updatingMovie!.length;
      releaseDateController.text = widget.updatingMovie!.releaseDate;
      imageController.text = widget.updatingMovie!.image;

      setState(() {
        staring = widget.updatingMovie!.staring;
      });
    }
  }

  void loadCategories() async {
    CategoriesService categoriesService = CategoriesService();
    var fetchedCategories = await categoriesService.fetchCategories();
    setState(() {
      choices = fetchedCategories.toList();
    });
    if (widget.updatingMovie != null) {
      for (var categorie in widget.updatingMovie!.categories) {
        categories.add(choices.firstWhere((element) => element.name == categorie).id);
      }
    }
  }

  void setSelectedValue(List<String> value) {
    setState(() => categories = value);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState){
        return Form(
          key: _formKey,
          child: AlertDialog(
            backgroundColor: Colors.grey[800],
            surfaceTintColor: Colors.transparent,
            title: widget.updatingMovie != null ? Text('Modifier un film') : Text('Ajouter un film'),
            content: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Expanded(
                child: SingleChildScrollView (
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: titleController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Nom du film",
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
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          maxLines: 5,
                          controller: synopsisController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Synospis du film",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          onFieldSubmitted: (e) {
                            if (actorController.text != "") {
                              setState(() {
                                staring.add(actorController.text);
                                actorController.text = "";
                                FocusManager.instance.primaryFocus?.unfocus();
                              });
                            }
                          },
                          controller: actorController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              alignment: Alignment.centerRight,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                if (actorController.text != "") {
                                  setState(() {
                                    staring.add(actorController.text);
                                    actorController.text = "";
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  });
                                }
                              },
                            ),
                            hintText: "Ajouter un acteur",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                          validator: (value) {
                            if (staring.isEmpty) {
                              return 'Ajouter un acteur';
                            }
                            return null;
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(staring.length, (index) {
                          String item = staring[index];
                          return ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  staring.removeAt(index);
                                });
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: movieLengthController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Durée du film",
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
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: imageController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Image du film (url)",
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
                      SizedBox(height: 20),
                      Choice<String>.inline(
                        multiple: true,
                        clearable: true,
                        value: categories,
                        onChanged: setSelectedValue,
                        itemCount: choices.length,
                        itemBuilder: (selection, i) {
                          return ChoiceChip(
                            backgroundColor: Colors.grey[700],
                            labelStyle: TextStyle(color: Colors.grey[300]),
                            selectedColor: Colors.red.shade900,
                            checkmarkColor: Colors.white,
                            selectedShadowColor: Colors.red.shade900,
                            shadowColor: Colors.red.shade900,
                            disabledColor: Colors.red.shade900,
                            surfaceTintColor: Colors.red.shade900,
                            selected: selection.selected(choices[i].id),
                            onSelected: selection.onSelected(choices[i].id),
                            label: Text("${choices[i].name.substring(0,1).toUpperCase()}${choices[i].name.substring(1).toLowerCase()}"),
                          );
                        },
                        listBuilder: ChoiceList.createScrollable(
                          spacing: 10,
                          runSpacing: 10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: releaseDateController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Date de sortie",
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
              ),
            ),
            actions: <Widget>[
              isLoading ? 
              Center(child: CircularProgressIndicator()) :
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.red.shade900,
                ),
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.red.shade900,
                ),
                child: const Text(
                  'Sauvegarder', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    if (widget.updatingMovie != null) {
                      MovieService().updateMovie(widget.updatingMovie!.id, titleController.text, synopsisController.text, imageController.text, staring, releaseDateController.text, movieLengthController.text, categories)
                      .then((value) => {
                        ElegantNotification.success(
                          title: Text("Ajout d'un film", style: TextStyle(color: Colors.black)),
                          description: Text("Validation de l'ajout du film", style: TextStyle(color: Colors.black)),
                        ).show(context),
                        Navigator.of(context).pop(value)
                      })
                      .catchError((err) => throw err)
                      .whenComplete(() => setState(() => isLoading = false));
                    } else {
                      MovieService().addMovie(titleController.text, synopsisController.text, imageController.text, staring, releaseDateController.text, movieLengthController.text, categories)
                      .then((value) => {
                        ElegantNotification.success(
                          title: Text("Ajout d'un film", style: TextStyle(color: Colors.black)),
                          description: Text("Validation de l'ajout du film", style: TextStyle(color: Colors.black)),
                        ).show(context),
                        Navigator.of(context).pop(value)
                      })
                      .catchError((err) => throw err)
                      .whenComplete(() => setState(() => isLoading = false));
                    }
                  }
                },
              ),
            ],
          )
        );
      }
    );
  }
}