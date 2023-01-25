import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateData extends StatefulWidget {
  UpdateData({super.key, this.data});
  Map<String, dynamic>? data;
  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? yerAdi;
  String? yerBilgisi;
  Function(GoogleMapController)? mapController; //contrller for Google map
  LatLng? selectedLocation;
  Set<Marker> markers = {};
  CameraPosition? initialCameraPosition;

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
        target: LatLng(double.parse(widget.data!["Lat"]),
            double.parse(widget.data!["Long"])),
        zoom: 5);
    markers.add(Marker(
        markerId: const MarkerId("A"),
        position: LatLng(double.parse(widget.data!["Lat"]),
            double.parse(widget.data!["Long"]))));
    selectedLocation = initialCameraPosition!.target;
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.data!["YerAdi"]),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.place_outlined),
                    hintText: 'Yeni Ad',
                    labelText: widget.data!["YerAdi"],
                  ),
                  onChanged: (value) => setState(() {
                    yerAdi = value;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.place_outlined),
                    hintText: 'Yeni Yer Bilgisi',
                    labelText: widget.data!["YerBilgisi"],
                  ),
                  onChanged: (value) => setState(() {
                    yerBilgisi = value;
                  }),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: GoogleMap(
                    initialCameraPosition: initialCameraPosition!,
                    markers: markers,
                    onTap: (argument) {
                      setState(() {
                        selectedLocation = argument;
                      });
                      setState(() {
                        markers.add(Marker(
                            markerId: MarkerId("A"),
                            position: selectedLocation!));
                      });
                    },
                    onMapCreated: mapController,
                  )),
              ElevatedButton(
                  onPressed: () {
                    updateDatas();
                  },
                  child: const Text("Kaydet"))
            ],
          ),
        ),
      ),
    );
  }

  updateDatas() async {
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: "gorkem@admin.com", password: "gorkem123")
        .then((kullanici) {
      FirebaseFirestore.instance
          .collection("Yerler")
          .doc(widget.data!["YerAdi"])
          .delete();
      FirebaseFirestore.instance
          .collection("Yerler")
          .doc(yerAdi)
          .set({'YerAdi': yerAdi, 'YerBilgisi': yerBilgisi, "Lat":"${selectedLocation!.latitude}", "Long":"${selectedLocation!.longitude}"}).whenComplete(
              () => Get.snackbar(
                    "Mission Complete!",
                    "Veriler Güncellendi!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue,
                    icon: const Icon(Icons.check),
                  ));
    });
  }
}
