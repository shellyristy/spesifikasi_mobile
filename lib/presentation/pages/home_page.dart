// ignore_for_file: deprecated_member_use, prefer_final_fields, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:auth_firebase/data/models/user_model.dart';
import 'package:auth_firebase/data/remote_data_source/firestore_helper.dart';
import 'package:auth_firebase/presentation/pages/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  Position? position;
  List<Placemark>? placeMarks;

  String completeAddress = "";
  
  
  getCurrentLocation() async {
    LocationPermission permission;
   permission = await Geolocator.requestPermission();
    
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];
    String completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
    _locationController.text = completeAddress;
  }

Future<Position> getLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(Exception('Location permissions are permanently denied.'));
    } 

    if (permission == LocationPermission.denied) {

      return Future.error(Exception('Location permissions are denied.'));
    }
  }

  return await Geolocator.getCurrentPosition();
}

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Firebase Create"),
        ),
        // Create Profile User
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "username"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Password"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Phone Number"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _locationController,
                enabled: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "My Location"),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 400,
                height: 40,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  label: const Text(
                    "Get my Current Location",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    getCurrentLocation();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FirestoreHelper.create(UserModel(
                    username: _usernameController.text,
                    name: _nameController.text,
                    password: _passwordController.text,
                    phone: _phoneController.text,
                    location: _locationController.text,
                  ));
                  // _create();
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Delete Profile
              StreamBuilder<List<UserModel>>(
                  stream: FirestoreHelper.read(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("some error occured"),
                      );
                    }
                    if (snapshot.hasData) {
                      final userData = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: userData!.length,
                            itemBuilder: (context, index) {
                              final singleUser = userData[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Delete"),
                                            content: const Text(
                                                "are you sure you want to delete"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    FirestoreHelper.delete(
                                                            singleUser)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text("Delete"))
                                            ],
                                          );
                                        });
                                  },
                                  // Read Profile
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Colors.deepPurple,
                                        shape: BoxShape.circle),
                                  ),
                                  title: Text("${singleUser.username}"),
                                  subtitle: Text(
                                      "${singleUser.name}, ${singleUser.password}, ${singleUser.phone}"),
                                  trailing: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditPage(
                                                      user: UserModel(
                                                          username: singleUser
                                                              .username,
                                                          name: singleUser.name,
                                                          password: singleUser
                                                              .password,
                                                          phone:
                                                              singleUser.phone,
                                                          id: singleUser.id),
                                                    )));
                                      },
                                      child: const Icon(Icons.edit)),
                                ),
                              );
                            }),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

// Future _create() async {
//   final userCollection = FirebaseFirestore.instance.collection("users");
//
//   final docRef = userCollection.doc();
//
//   await docRef.set({
//     "username": _usernameController.text,
//     "age": _ageController.text
//   });
//
//
// }
}
