import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../models/products.dart';
import '../widgets/image_input_form.dart';

class AddEditProduct extends StatefulWidget {
  static String routePath = "/addeditproduct";
  const AddEditProduct({Key? key}) : super(key: key);

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  bool intializeProduct = true;
  bool isLoading = false;

  // Product tempProduct = Product(
  //   id: DateTime.now().toString(),
  //   title: "",
  //   description: "",
  //   price: 0.0,
  //   imageUrl: "",
  // );

  Product tempProduct = Product();

  void validateAndSaveForm() {
    Products products = Provider.of<Products>(context, listen: false);
    bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();

    products.addUpdateProduct(tempProduct).then(
      (_) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (intializeProduct) {
      var modRoute = ModalRoute.of(context);
      tempProduct = modRoute != null && modRoute.settings.arguments != null
          ? modRoute.settings.arguments as Product
          : Product();
    }
    intializeProduct = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        actions: [
          IconButton(
            onPressed: validateAndSaveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: tempProduct.title,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) => tempProduct.setTitle = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title is mandatory";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: tempProduct.price > 0
                            ? tempProduct.price.toString()
                            : "",
                        decoration: const InputDecoration(
                          label: Text("Price"),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) =>
                            tempProduct.setPrice = double.parse(value ?? "0.0"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price is mandatory";
                          }
                          if (double.parse(value) < 0) {
                            return "Price can't be Negative";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: tempProduct.description,
                        decoration: const InputDecoration(
                          label: Text("Description"),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) => tempProduct.setDescription = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Description is mandatory";
                          }
                          if (value.length < 10) {
                            return "It should atleast be 10 Character long.";
                          }
                          return null;
                        },
                      ),
                      const Divider(),
                      ImageInputForm(
                        tempProduct: tempProduct,
                      ),
                    ],
                  )),
            ),
    );
  }
}
