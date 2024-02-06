import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    try {
      return await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.uid)
          .get();
    } catch (e) {
      // Handle errors more gracefully
      print("Error fetching user details: $e");
      rethrow;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 60,),
           Container(
             width: 100,
             height: 100,
             decoration: BoxDecoration(
               border: Border.all(
                 width: 4,
                 color: Colors.black,
               ),
             ),
             child: const Icon(Icons.person, size: 60,),
           ),
          const SizedBox(height: 20,),
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: getUserDetails(),
            builder: (context, snapshot) {
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // error
              else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              // data received
              else if (snapshot.hasData) {
                // extract data
                Map<String, dynamic>? user = snapshot.data!.data();
                if (user == null) {
                  return const Text("Error: User data is null");
                }
                return Column(
                  children: [
                    const Text('Username :',style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5,),
                    Text(
                      user['email'] ?? "No Email",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              } else {
                return const Text("Unknown error occurred");
              }
            },
          ),

          const SizedBox(height: 50,),
          const Text('LogOut :',style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500),),
          const SizedBox(height: 5,),
          SizedBox(
            width: 100,
            child: Material(

                color: Colors.blue,
                child: Column(
                  children: [
                    IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
                  ],
                )
            ),
          ),
          const SizedBox(height: 15,),



        ],
      ),
    );
  }
}
