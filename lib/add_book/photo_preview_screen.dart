import 'dart:io';

import 'package:booksy_2/add_book/add_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPreviewScreen extends StatefulWidget {
  const PhotoPreviewScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[_setImageView()],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSelectionDialog(context);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("De donde queres escoger la foto?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Galería"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camara"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    ImagePicker imagePicker =
        ImagePicker(); // Crear una instancia de ImagePicker
    var picture = await imagePicker.pickImage(
        source: ImageSource
            .gallery); // Utilizar la instancia para llamar al método pickImage
    if (picture != null) {
      Navigator.pop(context, File(picture.path));

      // Pasar la imagen seleccionada como resultado
    }
  }

  void _openCamera(BuildContext context) async {
    ImagePicker imagePicker =
        ImagePicker(); // Crear una instancia de ImagePicker
    var picture = await imagePicker.pickImage(
        source: ImageSource
            .camera); // Utilizar la instancia para llamar al método pickImage
    if (picture != null) {
      Navigator.pop(context, File(picture.path));
    }

    Widget _setImageView() {
      if (imageFile != null) {
        return Image.file(File(imageFile!.path), width: 500, height: 500);
      } else {
        return Text("Please select an image");
      }
    }

    // void _navigateAddBookBack(BuildContext context) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => AddBookScreen(),
    //     ),
    //   );
    // }
    // void _returnWithSelectedImage(BuildContext context, String imagePath) {
    //   Navigator.pop(context, imagePath);
    //   Navigator.pop(context, imagePath);
    // }
  }
}
