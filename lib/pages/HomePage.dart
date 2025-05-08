import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydailystore/Button/MyButton.dart';
import 'package:mydailystore/pages/CreateStorePage.dart';
import 'package:mydailystore/pages/ViewGrid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var profileUser = {};
  bool isLoading = false;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    userFetch();
  }

  void userFetch() async {
    setState(() {
      isLoading = true;
    });
    var userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {});
    profileUser = userdata.data()!;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Back ${profileUser['username']}"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then(
                      (e) => Navigator.pop(context),
                    );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('store')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Column(
                        children: [
                          MyButton(
                            title: DateFormat('yyyy-MM-dd')
                                .format(data[index]['Create_At'].toDate()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewGridPage(
                                    data: data[index]["Store"],
                                    id: data[index].id,
                                  ),
                                ),
                              );
                            },
                            color: Colors.white,
                            width: double.infinity,
                            bordercircle: 5,
                            fontSize: 15,
                            textColor: Colors.black,
                            splashColor: Colors.grey,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateStorePage(docId: data[index].id),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateStorePage(
                docId: '',
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.black,
        ),
      ),
    );
  }
}
