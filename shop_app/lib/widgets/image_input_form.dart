import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../models/product.dart';

class ImageInputForm extends StatefulWidget {
  const ImageInputForm({
    Key? key,
    required this.tempProduct,
  }) : super(key: key);
  final Product tempProduct;

  @override
  State<ImageInputForm> createState() => _ImageInputFormState();
}

class _ImageInputFormState extends State<ImageInputForm> {
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  bool intializeProduct = true;

  @override
  void didChangeDependencies() {
    if (intializeProduct) {
      _imageUrlController.text = widget.tempProduct.imageUrl;
    }
    intializeProduct = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _getPicture() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    //pickedImage.saveTo(appDir.path);
    await File(pickedImage.path).copy("${appDir.path}${pickedImage.name}");
    setState(() {
      _imageUrlController.text = "${appDir.path}${pickedImage.name}";
    });
    widget.tempProduct.setImage =
        await File(_imageUrlController.text).readAsBytes();
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    // final fileName = path.basename(imageFile.path);
    // final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    // widget.onSelectImage(savedImage);
  }

  Future<void> updateImageUrl() async {
    widget.tempProduct.setImageUrl = _imageUrlController.text;
    // if (!_imageUrlController.text.startsWith("http")) {
    //   widget.tempProduct.setImage =
    //       await File(_imageUrlController.text).readAsBytes();
    // }

    setState(() {});
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? Image.asset('assets/images/product-placeholder.png')
              : FittedBox(
                  child: _imageUrlController.text.startsWith("http")
                      ? Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          widget.tempProduct.image,
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Image URL"),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  controller: _imageUrlController,
                  //onFieldSubmitted: (_) => setState(() {}),
                  onEditingComplete: () => setState(() {}),
                  focusNode: _imageUrlFocusNode,
                  onSaved: (value) => widget.tempProduct.setImageUrl = value,
                  validator: (value) {
                    RegExp exp = RegExp(
                        r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
                    if (value != null && !exp.hasMatch(value)) {
                      return "Invalid URL!";
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _getPicture();
                },
                icon: const Icon(
                  Icons.local_movies,
                ),
                label: const Text("Browse Phone"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
