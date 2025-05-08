import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateStorePage extends StatefulWidget {
  final String docId;

  const CreateStorePage({super.key, required this.docId});

  @override
  State<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  DateTime date = DateTime.now();
  final auth = FirebaseAuth.instance.currentUser;
  final myid = Uuid().v4();

  final TextEditingController aboutController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

  Future<void> updateStore(String id) async {
    final amount = amountController.text;
    final about = aboutController.text;
    final fee = feeController.text;

    await FirebaseFirestore.instance.collection("store").doc(id).update(
      {
        'Create_At': DateTime.now(),
        'uid': FirebaseAuth.instance.currentUser!.uid,
        "Store": FieldValue.arrayUnion([
          {
            "amount": amount,
            "fee": fee,
            "about": about,
            'create_at': DateTime.now()
          }
        ]),
      },
    );
    Navigator.pop(context);
  }

  Future<void> saveStore() async {
    final amount = amountController.text;
    final about = aboutController.text;
    final fee = feeController.text;

    await FirebaseFirestore.instance.collection("store").add(
      {
        'Create_At': DateTime.now(),
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'id': Uuid().v4(),
        "Store": FieldValue.arrayUnion([
          {
            "amount": amount,
            "fee": fee,
            "about": about,
            'create_at': DateTime.now()
          }
        ]),
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
          iconSize: 35,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // ignore: unnecessary_null_comparison
              if (widget.docId == null) {
                saveStore();
              } else {
                updateStore(widget.docId);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${date.day}-${date.month}-${date.year}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Amount',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              controller: feeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'fee',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: aboutController,
                        maxLines: null,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'About',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
