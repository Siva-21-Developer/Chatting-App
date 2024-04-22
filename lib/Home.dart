import 'package:animate_do/animate_do.dart';
import 'package:chatapp/MessageBlock.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/newMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Loading indicator while fetching data
        }
        var userData = snapshot.data!.data();
        var username = userData!['UserName'];
        var userMobile = userData['Phone'];
        var userEmail = userData['Email'];
        final String? userImage = userData['ImgUrl'];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade200,
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.black),
            ),
            // flexibleSpace: Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('assets/'),
            //         fit: BoxFit.cover
            //     )
            //   ),
            // ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.white12,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:NetworkImage(userImage!),
                        backgroundColor: Colors.white,
                        radius: 40,
                      ),    const SizedBox(
                        height: 10,
                      ),
                      Text(
                        username,
                        style: const TextStyle(color: Colors.black, fontSize: 30),
                      )
                    ],
                  ),
                ),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title:  Text(
                    userMobile,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Divider(),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Divider(),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ), Icon(Icons.logout,color: Colors.white,)
                  ],),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false);
                  },
                ),
              ],
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white70,
                // image: DecorationImage(
                //   image: AssetImage('assets/back.png'),
                //   fit: BoxFit.cover,
                // ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(child: ChatMessages()),
                FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: const NewMessage())
              ],
            ),
          ),
        );
      },
    );
  }
}
