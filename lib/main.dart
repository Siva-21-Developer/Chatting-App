import 'package:chatapp/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'Register Page.dart';
import 'login page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =  const Settings(
    persistenceEnabled: true,
  );
  final user = FirebaseAuth.instance.currentUser!;
  final userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  final String name =userData.data()!['UserName'].toString();

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (BuildContext context, snapshot)
        {
          if(snapshot.hasData)
            {
              return  Home(name: name,);
            }
          return HomePage();
        },),
      )
  );
}





class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInUp(duration: const Duration(milliseconds: 1000), child:const Text("Welcome", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),)),
                  const SizedBox(height: 20,),
                  FadeInUp(duration: const Duration(milliseconds: 1200), child: Text("Automatic identity verification which enables you to verify your identity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15
                    ),)),
                ],
              ),
              FadeInUp(duration: const Duration(milliseconds: 1400), child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/illustration.png')
                    )
                ),
              )),
              Column(
                children: <Widget>[
                  FadeInUp(duration: const Duration(milliseconds: 1500), child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text("Login", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  )),
                  const SizedBox(height: 20,),
                  FadeInUp(duration: const Duration(milliseconds: 1600), child: Container(
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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                      },
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Text("Sign up", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}