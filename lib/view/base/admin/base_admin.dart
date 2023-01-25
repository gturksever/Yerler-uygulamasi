import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odev/view/base/admin/components/add_place.dart';
import 'package:odev/view/base/admin/components/update_place.dart';

import '../../../main.dart';

class BaseAdmin extends StatelessWidget {
  const BaseAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin"),
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
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPlace(),));
                }, child: const Text("Yer Ekle")),
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePlace(),));

                }, child: const Text("Yer Güncelle"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
