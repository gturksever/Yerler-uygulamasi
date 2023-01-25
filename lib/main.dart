import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:odev/view/base/admin/base_admin.dart';
import 'package:odev/view/base/normal_users/base_normal_users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: _title,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Center(
              child: Shortcuts(
                shortcuts: const <ShortcutActivator, Intent>{
                  // Pressing space in the field will now move to the next field.
                  SingleActivator(LogicalKeyboardKey.space): NextFocusIntent(),
                },
                child: FocusTraversalGroup(
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      Form.of(primaryFocus!.context!)?.save();
                    },
                    child: Wrap(
                      children: List<Widget>.generate(2, (int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tight(const Size(200, 65)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: index == 0
                                    ? const Icon(Icons.person)
                                    : const Icon(Icons.password),
                                hintText: index == 0
                                    ? 'kullanici_adi@normal.com'
                                    : "*********",
                                labelText: index == 0 ? 'Username' : "Password",
                              ),
                              onSaved: (String? value) {
                                if (value!.contains("@")) {
                                  setState(() {
                                    t1.text = value;
                                  });
                                } else {
                                  setState(() {
                                    t2.text = value;
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  kayitOl();
                },
                child: const Text("Kayıt Ol")),
            ElevatedButton(
                onPressed: () {
                  girisYap();
                },
                child: const Text("Giris Yap")),
          ],
        ),
      ),
    );
  }

  Future<void> kayitOl() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      FirebaseFirestore.instance
          .collection("Kullanicilar")
          .doc(t1.text)
          .set({"KullaniciEposta": t1.text, "KullaniciSifre": t2.text});
    });
  }

  Future<void> girisYap() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
          if(kullanici.user!.email!.contains("@admin")){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BaseAdmin(),));
          } else if (kullanici.user!.email!.contains("@normal")){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BaseNormalUsers(),));
          } else {
            debugPrint("Kullanıcı harici giriş yapmaktadır.");
          }
    }).whenComplete(() => Get.snackbar(
            "Giriş Başarılı!",
            "",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.check),
          ));
  }
}
