import 'package:animate_do/animate_do.dart';
import 'package:chatapp/MessageBlock.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/newMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.name});

  final String name;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Color myColor = const Color(0x0a6a6a6);
  var TextColor = Colors.black;
  var username = '';

  @override
  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!;
    final users = FirebaseFirestore.instance.collection('users').doc(userid.uid).get();



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text("Home", style: TextStyle(color: TextColor),),
      ),
        // extendBodyBehindAppBar: true,
        drawer: Drawer(
          backgroundColor: Colors.white12,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
               DrawerHeader(
                 padding: const EdgeInsets.only(left: 10,top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white70,
                ),
                child:Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/ava.jpg'),
                    ),
                    const SizedBox(height: 10,),
                    Text(widget.name, style: const TextStyle(color: Colors.black, fontSize: 30,),)
                  ],
                ),
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text('Logout', style: TextStyle(color: Colors.white),),
                onTap: ()
                {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => HomePage()), (
                      route) => false);
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
            image: DecorationImage(image: AssetImage('assets/back.png'),
              fit: BoxFit.cover,),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: ChatMessages()),
              FadeInUp(duration: const Duration(milliseconds: 1000), child:NewMessage())
            ],
          ),
        ),
    );
  }
}



//
// userData() async {
//      final user = FirebaseAuth.instance.currentUser!;
//      final userdata = await FirebaseFirestore.instance.collection('users')
//      .doc(user.uid).get();
//      setState(() {
//        username = userdata.data()!["UserName"];
//      });
//        return username.toString().toUpperCase();
//    }




// child: StreamBuilder(
// stream: FirebaseFirestore.instance.collection('users').snapshots(),
// builder: (context, snapshots) {
// if (snapshots.hasData) {
// final data = snapshots.data!.docs;
// return ListView.builder(
//
// itemCount: data.length,
// itemBuilder: (context, index) {
// final chatMessage = data[index].data();
// return GestureDetector(
// onTap: () {},
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// height: 70,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// color: Colors.grey.withOpacity(0.3)),
// child: Padding(
// padding: const EdgeInsets.only(left: 20),
// child: Row(
// children: [
// const CircleAvatar(
// radius: 20,
// backgroundImage: AssetImage('assets/ava.jpg'),
// backgroundColor: Colors.black12,
// ),
// const SizedBox(
// width: 20,
// ),
// Text(
// chatMessage['UserName'].toString().toUpperCase(),
// style: const TextStyle(
// fontSize: 17, fontWeight: FontWeight.bold),
// )
// ],
// ),
// ),
// ),
// ),
// );
//
// });
// }
// return const Text(" No data");
// },
// )



//
// StreamBuilder(
// stream: FirebaseFirestore.instance.collection('users').doc(userid.toString()).snapshots(),
// builder: (context, snapshots) {
// var usernames = snapshots.data!.data();
// if (snapshots.hasData) {
// return Text(usernames!['UserName']);
// }
// return const Text(" No data");
// },
// )


