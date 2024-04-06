import 'package:flutter/material.dart';
import 'Connexion.dart';
import '../services/users/users_register.dart';
import 'package:elegant_notification/elegant_notification.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  InscriptionState createState() {
    return InscriptionState();
  }
}

class InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();

  bool passenable = true;
  bool passenableRepeated = true;
  bool isLoading = false;
  bool toLogin = false;

  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(toLogin){
      return Connexion();
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.movie,
                  color: Colors.red.shade800,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  'Luminous Movies',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
              controller: pseudoController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Pseudo",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20)
              ),
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20)
              ),
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Entrer une adresse mail';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return "Format de mail invalide";
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
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: passenable,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Mot de passe",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
                suffix: IconButton(onPressed: (){
                  setState(() {
                    if(passenable){
                      passenable = false;
                    }else{
                      passenable = true;
                    }
                  });
                }, icon: Icon(passenable == true?Icons.visibility:Icons.visibility_off), color: Colors.grey.shade400)
              ),
              validator: (value){
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
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextFormField(
              controller: repeatedPasswordController,
              obscureText: passenableRepeated,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Confirmez le mot de passe",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
                suffix: IconButton(onPressed: (){
                  setState(() {
                      if(passenableRepeated){
                        passenableRepeated = false;
                      }else{
                        passenableRepeated = true;
                      }
                  });
                }, icon: Icon(passenableRepeated == true?Icons.visibility:Icons.visibility_off), color: Colors.grey.shade400)
              ),
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (repeatedPasswordController.text != passwordController.text) {
                  return 'Les mots de passe ne sont pas identique';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          isLoading ? Center(child:CircularProgressIndicator()) 
          : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red.shade900)
            ),
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                setState(() => isLoading = true );
                UserRegister()
                  .addUser(emailController.text, passwordController.text, pseudoController.text)
                  .then((value) => {
                    ElegantNotification.success(
                      title:  Text("Inscription"),
                      description:  Text("Validation de l'inscription."),
                    ).show(context)
                  })
                  .catchError((err) => throw err)
                  .whenComplete(() => setState(() => isLoading = false ));
              }
            }, 
            child: Text('Inscription', style: TextStyle(color: Colors.white))
          ),
          TextButton(
              onPressed: (){
                setState(() => toLogin = true);
              }, 
            child: Text("Se connecter", style: TextStyle(color: Colors.white),)
          ),
          
        ]
      ),
    );
  }
}