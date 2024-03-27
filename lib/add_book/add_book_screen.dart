// import 'dart:io';

import 'dart:io';

import 'package:booksy_2/services/book_services.dart';
import 'package:camera/camera.dart';
// import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
// import "package:booksy_2/add_book/photo_preview_screen.dart";
// import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Nuevo libro"),
      ),
      body: AddBookForm(),
    );
  }
}

class AddBookForm extends StatefulWidget {
  const AddBookForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddBookFormState();
  }
}

class AddBookFormState extends State<AddBookForm> {
  final titleFiledController = TextEditingController();
  final authorFiledController = TextEditingController();
  String selectedCategory = "Romance";
  final descriptionFiledController = TextEditingController();
  final coverUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _savingBook = false;

  XFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: titleFiledController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Título",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "por favor ingresa un título";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: authorFiledController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Autor",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "por favor ingresa un autor";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Categoría', // Establece el texto del label
                    border:
                        UnderlineInputBorder(), // Establece el borde del campo
                  ),
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: <String>[
                    "Romance",
                    "Ciencia Ficcion",
                    "Aventura",
                    "Fantasia"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: descriptionFiledController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Resumen",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "por favor ingresa un resumen";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      _showSelectionDialog(context);
                    },
                    child: SizedBox(
                      width: 120,
                      child: _getImageWidget(context),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveBook(context);
                      }
                    },
                    child: Text("Guardar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        pickedFile = imageFile;
        coverUrlController.text = pickedFile!.path;
      });

      Navigator.of(context).pop();
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        pickedFile = imageFile;
        coverUrlController.text = pickedFile!.path;
      });

      Navigator.of(context).pop();
    }
  }

  Widget _getImageWidget(BuildContext context) {
    if (pickedFile != null && pickedFile!.path.isNotEmpty) {
      return Image.file(File(pickedFile!.path));
    } else {
      return Image.asset("assets/images/camara.png");
    }
  }

  void _saveBook(BuildContext context) async {
    var title = titleFiledController.text;
    var author = authorFiledController.text;
    String category = selectedCategory;
    var description = descriptionFiledController.text;
    var coverUrl = coverUrlController.text;
    //le mamnda al service

    //vacia los campos
    titleFiledController.clear();
    authorFiledController.clear();
    //categoryFiledController.clear();
    descriptionFiledController.clear();
    //imprime mensaje de accion exitosa
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Libro creado",
        ),
      ),
    );
    setState(() {
      _savingBook = true;
    });
    var newBookId = await BooksService()
        .saveBook(title, author, category, description, coverUrl);

    if (coverUrl != null) {
      String imageurl = await BooksService().uploadCover(coverUrl!, newBookId);

      await BooksService().updateCoverBook(newBookId, imageurl);
    }
  }
}
