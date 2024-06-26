import 'package:animate_do/animate_do.dart';
import 'package:chatapp/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'Home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  Future<bool> Registers() => Future.delayed(const Duration(seconds: 2),()=> true);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  var kBackgroundColor = Colors.black;
  File? _selectedImage;

  TextEditingController UserName = TextEditingController();
  TextEditingController PhoneNumber = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void register() async{
    try{
      if(Password.text == confirmPassword.text)
      {
        final AccountCreate = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: Email.text, password: Password.text);
        //return userCredential.user;
        final StorageRef = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child('${AccountCreate.user!.uid}.jpg');
        await StorageRef.putFile(_selectedImage!);
        final url_image = await StorageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection("users").doc(AccountCreate.user!.uid).set({
          'UserName': UserName.text,
          'Phone' : PhoneNumber.text,
          'ImgUrl' : url_image,
          'Email' : Email.text,

        });
        if (AccountCreate.user != null)
        {
           // Navigator.pushAndRemoveUntil(
           //    context, MaterialPageRoute(builder: (context) => Home()), (
           //    route) => false);

           if (await widget.Registers()) {
             if (context.mounted) {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => const Home(),
                 ),
               );
             }
           }

        }
      }
      else
      {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Password is mismatch')));
      }
    }
    on FirebaseAuthException catch(error)
    {
      if (error == 'email-already-in-use') {}
      if(context.mounted)
        {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.message ?? '')));
        }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
            
                    FadeInUp(duration: const Duration(microseconds: 1000), child:    Image_uploads(
                      onPickImage: (File pickedImage) {
                        _selectedImage = pickedImage;
                      },
                    ),
                    ),

                    FadeInUp(duration: const Duration(milliseconds: 1000), child: const Text("Sign up", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),)),
                    const SizedBox(height: 20,),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FadeInUp(duration: const Duration(milliseconds: 1200), child: makeInput(label: "User Name", controllers:UserName, Color_s: kBackgroundColor)),
                    FadeInUp(duration: const Duration(milliseconds: 1200), child: makeInput(label: "Phone", controllers:PhoneNumber, Color_s: kBackgroundColor)),
                    FadeInUp(duration: const Duration(milliseconds: 1200), child: makeInput(label: "Email", controllers:Email, Color_s: kBackgroundColor)),
                    FadeInUp(duration: const Duration(milliseconds: 1300), child: makeInput(label: "Password", obscureText: true, controllers: Password,Color_s: kBackgroundColor)),
                    FadeInUp(duration: const Duration(milliseconds: 1400), child: makeInput(label: "Confirm Password", obscureText: true, controllers: confirmPassword,Color_s: kBackgroundColor)),
                  ],
                ),
                FadeInUp(duration: const Duration(milliseconds: 1500), child: Container(
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
                    onPressed: register,
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text("Sign up", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  ),
                )),
                FadeInUp(duration: const Duration(milliseconds: 1600), child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    Text(" Login", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                    ),),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false, controllers, Color_s}) {
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
          controller: controllers,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color_s)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color:Color_s)
            ),
          ),
        ),
        const SizedBox(height: 30,),
      ],
    );
  }
}