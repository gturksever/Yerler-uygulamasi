import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  String? getDownloadURL;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final picker = ImagePicker();
  File? image;
  Function(GoogleMapController)? mapController; //contrller for Google map
  CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(39.99416282971196, 32.93656166349589), zoom: 5);
  LatLng? selectedLocation;
  Set<Marker> markers = {};
  TextEditingController placeName = TextEditingController();
  TextEditingController placeInfo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            Row(
              children: [
                const Text("Yer Ekle"),
                IconButton(
                    onPressed: () {
                      _AddPlace();
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.place_outlined),
                      hintText: 'Ankara',
                      labelText: 'Yer Adı',
                    ),
                    onChanged: (value) => setState(() {
                      placeName.text = value;
                    }),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.place_outlined),
                      labelText: 'Yer hakkında bilgi',
                    ),
                    onChanged: (value) => setState(() {
                      placeInfo.text = value;
                    }),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onImageButtonPressed(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text(
                    "Fotoğraf Çek",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onImageButtonPressed(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text(
                    "Galeriden Seç",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: image == null
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Fotoğraf seçilmedi.'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(image!),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              (selectedLocation == null)
                  ? Text("Lütfen Konum Seçiniz")
                  : Text(
                      "Lat:${selectedLocation!.latitude.toStringAsFixed(4)} Long:${selectedLocation!.longitude.toStringAsFixed(4)}"),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: GoogleMap(
                    initialCameraPosition: initialCameraPosition,
                    markers: markers,
                    onTap: (argument) {
                      setState(() {
                        selectedLocation = argument;
                        markers.add(
                          Marker(
                              markerId: const MarkerId(Unicode.ALM),
                              position: selectedLocation!),
                        );
                      });
                    },
                    onMapCreated: mapController,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  onImageButtonPressed(ImageSource source) async {
    try {
      await getImage(source);
    } catch (e) {}
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  Future<void> _AddPlace() async {
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: "gorkem@admin.com", password: "gorkem123")
        .then((kullanici) {
      FirebaseFirestore.instance.collection("Yerler").doc(placeName.text).set({
        "YerAdi": placeName.text,
        "YerBilgisi": placeInfo.text,
        "Lat": "${selectedLocation!.latitude}",
        "Long": "${selectedLocation!.longitude}"
      }).whenComplete(() => Get.snackbar(
            "Mission Complete!",
            "Veriler Yüklendi!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.check),
          ));
    });
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage
        .ref()
        .child("yerler")
        .child(firebaseAuth.currentUser!.uid)
        .child("yerler.png");
      UploadTask uploadTask = reference.putFile(image!);
      uploadTask;
  }
}
