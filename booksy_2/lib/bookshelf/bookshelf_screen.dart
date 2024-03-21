import 'package:booksy_2/services/book_services.dart';
import 'package:booksy_2/state.dart';
import 'package:flutter/material.dart';
import 'package:booksy_2/model/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booksy_2/book_details/book_details_screen.dart';

class BookShelfScreen extends StatelessWidget {
  const BookShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookShelfBloc, BookShelfState>(
        builder: (context, BookShelfState) {
      if (BookShelfState.bookIds.isEmpty) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Center(
            child: Text("Aún no tienes ningún libro en la biblioteca",
                style: TextStyle(fontSize: 25, color: Colors.grey),
                textAlign: TextAlign.center),
          ),
        );
      }
      return Container(
        margin: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: BookShelfState.bookIds.length,
          itemBuilder: (BuildContext context, index) {
            return BookCoveritem(BookShelfState.bookIds[index]);
          },
        ),
      );
    });
  }
}

class BookCoveritem extends StatefulWidget {
  final String _bookId;
  const BookCoveritem(this._bookId, {super.key});

  @override
  State<BookCoveritem> createState() => _BookCoveritemState();
}

class _BookCoveritemState extends State<BookCoveritem> {
  Book? _book;

  void initState() {
    super.initState();
    _getBook(widget._bookId);
  }

  void _getBook(String bookId) async {
    var book = await BooksService().getBook(bookId);
    setState(() {
      _book = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_book == null) {
      return Center(child: CircularProgressIndicator());
    }
    return InkWell(
      onTap: () {
        _openBookDetalils(context, _book!);
      },
      child: Ink.image(fit: BoxFit.cover, image: AssetImage(_book!.coverUrl)),
    );
  }

  _openBookDetalils(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book),
      ),
    );
  }
}
