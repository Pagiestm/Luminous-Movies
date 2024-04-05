import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  ConnexionState createState() {
    return ConnexionState();
  }
}

class ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();

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
          Container(
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(20)
            ),
            child: PasswordField(
              color: Colors.blue,
              passwordDecoration: PasswordDecoration(
              ),
              
              hintText: 'must have special characters',
              border: PasswordBorder(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade100,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                
              ),
            ),
          ),
        ]
      ),
    );
  }
}