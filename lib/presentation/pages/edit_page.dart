
import 'package:auth_firebase/data/models/user_model.dart';
import 'package:auth_firebase/data/remote_data_source/firestore_helper.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final UserModel user;
  const EditPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController? _usernameController;
  TextEditingController? _nameController;
  TextEditingController? _passwordController;
  TextEditingController? _phoneController;
  TextEditingController? _locationController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.user.username);
    _nameController = TextEditingController(text: widget.user.name);
    _passwordController = TextEditingController(text: widget.user.password);
    _phoneController = TextEditingController(text: widget.user.phone);
    _locationController = TextEditingController(text: widget.user.location);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController!.dispose();
    _nameController!.dispose();
    _passwordController!.dispose();
    _phoneController!.dispose();
    _locationController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "username"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "password"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "phone"),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  FirestoreHelper.update(UserModel(id: widget.user.id, username: _usernameController!.text, name: _nameController!.text, password: _passwordController!.text, phone: _phoneController!.text, location: _locationController!.text),).then((value) {
                    Navigator.pop(context);
                  });
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
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}