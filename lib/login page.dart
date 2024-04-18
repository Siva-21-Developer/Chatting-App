import 'package:animate_do/animate_do.dart';
import 'package:chatapp/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    TextEditingController Email = TextEditingController();
    TextEditingController Password = TextEditingController();


    Future<User?> Login()
    async {
      final user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final String name =userData.data()!['UserName'].toString();
      if(Password.text.isNotEmpty || Email.text.isNotEmpty)
        {
          try
          {
            if(!Password.text.isEmpty || !Email.text.isEmpty)
            {
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: Email.text, password: Password.text);
              // return userCredential.user;
              if (userCredential.user != null) {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => Home(name: name,)), (
                    route) => false);
              }

            }
          }
          on FirebaseAuthException catch(error)
          {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.message ?? '')));
          }

        }
      else
        {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Please Enter the value')));

        }

    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(duration: const Duration(milliseconds: 1000), child: const Text("Login", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),)),
                      const SizedBox(height: 20,),
                      FadeInUp(duration: const Duration(milliseconds: 1200), child: Text("Login to your account", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                      ),)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(duration: const Duration(milliseconds: 1200), child: makeInput(label: "Email", Controller: Email)),
                        FadeInUp(duration: const Duration(milliseconds: 1300), child: makeInput(label: "Password", obscureText: true, Controller: Password)),
                      ],
                    ),
                  ),
                  FadeInUp(duration: const Duration(milliseconds: 1400), child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: const Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: Login,
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Text("Login", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    ),
                  )),
                  FadeInUp(duration: const Duration(milliseconds: 1500), child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      Text("Sign up", style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                    ],
                  ))
                ],
              ),
            ),
            FadeInUp(duration: const Duration(milliseconds: 1200), child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover
                  )
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false,Controller }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        const SizedBox(height: 5,),
        TextField(
          obscureText: obscureText,
          controller: Controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            ),
          ),
        ),
        const SizedBox(height: 30,),
      ],
    );
  }
}