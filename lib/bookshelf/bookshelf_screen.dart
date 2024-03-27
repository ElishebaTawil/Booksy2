import 'package:booksy_2/add_book/add_book_screen.dart';
import 'package:booksy_2/services/book_services.dart';
import 'package:booksy_2/state.dart';
import 'package:flutter/material.dart';
import 'package:booksy_2/model/book.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booksy_2/book_details/book_details_screen.dart';

class BookShelfScreen extends StatelessWidget {
  const BookShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookShelfBloc, BookShelfState>(
        builder: (context, BookShelfState) {
      var emptyListWidget = Container(
        margin: EdgeInsets.all(10),
        child: Center(
          child: Text("Aún no tienes ningún libro en la biblioteca",
              style: TextStyle(fontSize: 25, color: Colors.grey),
              textAlign: TextAlign.center),
        ),
      );
      var mainWidget = BookShelfState.bookIds.isEmpty
          ? emptyListWidget
          : MyBooksGrid(BookShelfState.bookIds);

      return Column(
        children: [
          Expanded(child: mainWidget),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                _navigateToAddNewBookScreen(context);
              },
              child: Text("Agregar nuevo libro"),
            ),
          ),
        ],
      );
    });
  }

  void _navigateToAddNewBookScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddBookScreen(),
      ),
    );
  }
}

class MyBooksGrid extends StatelessWidget {
  final List<String> booksIds;
  const MyBooksGrid(this.booksIds, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: booksIds.length,
        itemBuilder: (BuildContext context, index) {
          return BookCoveritem(booksIds[index]);
        },
      ),
    );
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
      child: Ink.image(fit: BoxFit.cover, image: _getImageFor(_book!.coverUrl)),
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

  ImageProvider<Object> _getImageFor(String coverUrl) {
    if (coverUrl.startsWith("https")) {
      return NetworkImage(coverUrl);
    } else {
      return AssetImage(_book!.coverUrl);
    }
  }
}
