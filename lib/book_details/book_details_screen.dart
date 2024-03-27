import "package:booksy_2/model/book.dart";
import 'package:booksy_2/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book _book;
  const BookDetailsScreen(this._book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("detalle libro"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookCoverWidget(_book.coverUrl),
            BookInfoWidget(
                _book.title, _book.author, _book.category, _book.description),
            SizedBox(height: 15),
            ButtonWidget(_book.id),
          ],
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String bookId;
  const ButtonWidget(this.bookId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookShelfBloc, BookShelfState>(
        builder: (context, BookShelfState) {
      var action = () => _addToBookshelf(context, bookId);
      var label = "Agregar al Estante";
      var color = Colors.amber;

      if (BookShelfState.bookIds.contains(bookId)) {
        action = () => _removeToBookshelf(context, bookId);
        label = "Quitar del Estante";
        color = Colors.grey;
      }
      return Container(
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: action,
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: color),
        ),
      );
    });
  }
}

void _addToBookshelf(BuildContext context, String bookId) {
  var bookShelfBloc = context.read<BookShelfBloc>();
  bookShelfBloc.add(AddBookToBookShelf(bookId));
}

void _removeToBookshelf(BuildContext context, String bookId) {
  var bookShelfBloc = context.read<BookShelfBloc>();
  bookShelfBloc.add(RemoveBookFromBookShelf(bookId));
}

class BookInfoWidget extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final String description;
  const BookInfoWidget(this.title, this.author, this.category, this.description,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 5),
          Text(
            author,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5),
          Text(
            category,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}

class BookCoverWidget extends StatelessWidget {
  final String _coverUrl;
  const BookCoverWidget(this._coverUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: 230,
      child: _getImageFor(_coverUrl),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
    );
  }

  _getImageFor(String coverUrl) {
    if (coverUrl.startsWith("https")) {
      return Image.network(coverUrl);
    } else {
      return Image.asset(coverUrl);
    }
  }
}
