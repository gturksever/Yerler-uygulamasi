import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odev/view/base/admin/components/update_data.dart';

class UpdatePlace extends StatefulWidget {
  const UpdatePlace({super.key});

  @override
  State<UpdatePlace> createState() => _UpdatePlaceState();
}

class _UpdatePlaceState extends State<UpdatePlace> {
  
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Yerler').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yer Güncelle"),),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateData(data: data),));
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
