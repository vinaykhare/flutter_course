import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/address.dart';
import '../models/user_address.dart';
import 'add_edit_address.dart';
import 'order_summary.dart';

enum SingingCharacter { lafayette, jefferson }

class AddressPage extends StatefulWidget {
  static String routePath = "/address_page";
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  Address? selectedAddress;
  @override
  Widget build(BuildContext context) {
    UserAddress addressList = Provider.of<UserAddress>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Address"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddEditAddress.routePath),
            icon: const Icon(Icons.add_location_alt_rounded),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var address = addressList.userAddressList[index];

                return RadioListTile<Address>(
                  //key: Key(address.id ?? DateTime.now().toIso8601String()),
                  //toggleable: true,
                  groupValue: selectedAddress,
                  title: Card(
                    child: Column(
                      children: [
                        Text(address.houseNo ?? ""),
                        Text(address.addressLine ?? ""),
                        Text("Near ${address.landmark ?? "N/A"} "),
                        Text(address.city ?? ""),
                        Text(address.pincode ?? ""),
                        Text(address.state ?? ""),
                        Text(
                            "Location on Map with Latitude ${address.latitude} and Longitude ${address.longitude}"),
                      ],
                    ),
                  ),
                  onChanged: (Address? value) {
                    setState(
                      () {
                        selectedAddress = value;
                      },
                    );
                    // ignore: avoid_print
                    print("Selected Address is: $selectedAddress");
                  },
                  value: addressList.userAddressList[index],
                );
              },
              itemCount: addressList.userAddressList.length,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(
                OrderSummary.routePath,
                arguments: selectedAddress,
              );
            },
            icon: const Icon(Icons.location_pin),
            label: const Text("Confirm Address"),
          ),
        ],
      ),
    );
  }
}
