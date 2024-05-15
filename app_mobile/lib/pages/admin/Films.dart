import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/models/categories.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/services/categories/categories.dart';
import '../../services/movies/movies.dart';
import 'package:choice/choice.dart';

class Films extends StatefulWidget {
  const Films({super.key});

  @override
  FilmsState createState() {
    return FilmsState();
  }
}

class FilmsState extends State<Films> {
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

  void initState() {
    super.initState();
    // Appel de la méthode pour charger les catégories
    loadCategories();
  }

  void loadCategories() async {
    CategoriesService categoriesService = CategoriesService();
    var fetchedMovies = await categoriesService.fetchCategories();
    setState(() {
      choices = fetchedMovies.toList();
    });
  }

  void setSelectedValue(List<String> value) {
    setState(() => categories = value);
    print(categories);
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
                title: Text('Films', style: GoogleFonts.getFont('Sora')),
                backgroundColor: Colors.black,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_sharp),
                    onPressed: () {
                      _addMovie(context);
                    },
                  ),
                ]
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: MovieService().fetchMovies(), 
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  List<Movie> movies = snapshot.data as List<Movie>;
                  List<Movie> moviesReversed = movies.reversed.toList();
                  return Container(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      shrinkWrap: true,
                      itemCount: movies.length,
                      itemBuilder: (context, index){
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.movie),
                                title: Text(moviesReversed[index].title),
                                subtitle: Text(
                                  "${moviesReversed[index].releaseDate} - ${moviesReversed[index].length}"
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  moviesReversed[index].synopsis,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: GoogleFonts.getFont('Sora'),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Modifier'),
                                    onPressed: () { /* ... */ },
                                  ),
                                  TextButton(
                                    child: const Text('Supprimer'),
                                    onPressed: () { 
                                      MovieService().deleteMovieById(moviesReversed[index].id).then((value) => {
                                        setState(() {
                                          moviesReversed.removeWhere((element) => element.id == moviesReversed[index].id);
                                        })
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMovie(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState){
            return Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text('Ajouter un film'),
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
                                backgroundColor: Colors.grey[600],
                                labelStyle: TextStyle(color: Colors.grey[400]),
                                selected: selection.selected(choices[i].id),
                                onSelected: selection.onSelected(choices[i].id),
                                label: Text(choices[i].name),
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
                    ),
                    child: const Text('Sauvegarder'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        MovieService().addMovie(titleController.text, synopsisController.text, imageController.text, staring, releaseDateController.text, movieLengthController.text, categories)
                        .then((value) => {
                          ElegantNotification.success(
                            title: Text("Ajout d'un film", style: TextStyle(color: Colors.black)),
                            description: Text("Validation de l'ajout du film", style: TextStyle(color: Colors.black)),
                          ).show(context),
                          Navigator.of(context).pop()
                        })
                        .catchError((err) => throw err)
                        .whenComplete(() => setState(() => isLoading = false));
                      }
                    },
                  ),
                ],
              )
            );
          }
        );
      },
    );
  }
}
