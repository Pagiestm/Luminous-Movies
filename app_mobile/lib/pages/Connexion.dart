import 'package:flutter/material.dart';
import '../services/users/users_auth.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  ConnexionState createState() {
    return ConnexionState();
  }
}

class ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();
  bool passenable = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          isLoading ? Center(child:CircularProgressIndicator()) 
          : ElevatedButton(
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                  isLoading = true;
                  UserAuth()
                    .fetchUser(emailController.text, passwordController.text)
                    .catchError((e) => throw e)
                    .whenComplete(() => isLoading = false);
                    setState(() {});
              }
            }, 
            child: Text('submit')
          ),
        ]
      ),
    );
  }
}