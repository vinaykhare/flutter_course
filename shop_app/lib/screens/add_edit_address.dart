import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../models/user_address.dart';

class AddEditAddress extends StatefulWidget {
  static String routePath = "/add_edit_address";
  const AddEditAddress({Key? key}) : super(key: key);

  @override
  State<AddEditAddress> createState() => _AddEditAddressState();
}

class _AddEditAddressState extends State<AddEditAddress> {
  final _formKey = GlobalKey<FormState>();
  Address userAddress = Address();

  void validateAndSaveForm() {
    // bool valid = _formKey.currentState?.validate() ?? false;
    // if (!valid) {
    //   return;
    // }
    _formKey.currentState!.save();
    Provider.of<UserAddress>(context, listen: false).addAddress(userAddress);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Address"),
        actions: [
          ElevatedButton.icon(
            onPressed: validateAndSaveForm,
            icon: const Icon(Icons.store),
            label: const Text("Save"),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text("House No."),
              ),
              onSaved: (value) => userAddress.houseNo = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Address Lines"),
              ),
              onSaved: (value) => userAddress.addressLine = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Landmark"),
              ),
              onSaved: (value) => userAddress.landmark = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Pincode"),
              ),
              onSaved: (value) => userAddress.pincode = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("City"),
              ),
              onSaved: (value) => userAddress.city = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("State"),
              ),
              onSaved: (value) => userAddress.state = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Latitude"),
              ),
              onSaved: (value) => userAddress.latitude = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Longitude"),
              ),
              onSaved: (value) => userAddress.longitude = value,
            ),
            Image.asset("assets/images/dummy_map.png"),
          ],
        ),
      ),
    );
  }
}
