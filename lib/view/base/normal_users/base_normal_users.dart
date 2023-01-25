import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odev/view/base/normal_users/components/show_datas.dart';

import '../../../main.dart';

class BaseNormalUsers extends StatefulWidget {
  const BaseNormalUsers({super.key});

  @override
  State<BaseNormalUsers> createState() => _BaseNormalUsersState();
}

class _BaseNormalUsersState extends State<BaseNormalUsers> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Yerler').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then(
                  (deger) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                );
              }),
        ],
        leading: Container(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowDatas(
                            data: data,
                          ),
                        ));
                  },
                  child: ListTile(
                    title: Text(data["YerAdi"]),
                    subtitle: Text(data["YerBilgisi"]),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
