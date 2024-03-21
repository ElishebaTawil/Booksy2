import 'package:booksy_2/categories/category_screen_detail.dart';
import 'package:booksy_2/model/book_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BookCategoriesGrid();
  }
}

class BookCategoriesGrid extends StatelessWidget {
  BookCategoriesGrid({super.key});

  final List<BookCategory> _categories = [
    const BookCategory(
        1, "Ciencia Ficcion", "assets/images/cienciaFiccion.jpg"),
    const BookCategory(2, "Romance", "assets/images/romance.jpg"),
    const BookCategory(3, "Aventura", "assets/images/aventura.jpg"),
    const BookCategory(4, "Fantasia", "assets/images/fantasia.jpg"),
    const BookCategory(
        5, "Ciencia Ficcion", "assets/images/cienciaFiccion.jpg"),
    const BookCategory(6, "Romance", "assets/images/romance.jpg"),
    const BookCategory(7, "Aventura", "assets/images/aventura.jpg"),
    const BookCategory(8, "Fantasia", "assets/images/fantasia.jpg")
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: GridView.builder(
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return TileCatergory(_categories[index]);
          }),
    );
  }
}

class TileCatergory extends StatelessWidget {
  final BookCategory _category;
  const TileCatergory(this._category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: InkWell(
          onTap: () {
            _navigateToBookswithCategory(context, _category);
            //TODO navegar a los libros
          },
          child: Stack(
            fit: StackFit
                .expand, // Expandir la imagen para llenar todo el espacio de la tarjeta
            children: [
              // Imagen de fondo
              Image.asset(
                _category.coverUrl,
                fit: BoxFit.cover,
              ),

              // Contenedor con opacidad
              Container(
                color: Colors.black
                    .withOpacity(0.3), // Ajusta la opacidad aquí (0.0 a 1.0)
              ),

              // Contenedor para el texto centrado
              Container(
                alignment: Alignment.center,
                child: Text(
                  _category.name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _navigateToBookswithCategory(BuildContext context, BookCategory category) {
  //TODO navergar a pantalla de lista de libros de la categoria

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CategoryScreen(category.name),
    ),
  );
}
