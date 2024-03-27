import 'package:booksy_2/book_details/book_details_screen.dart';
import 'package:booksy_2/model/book.dart';
import 'package:flutter/material.dart';
import 'package:booksy_2/services/book_services.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  CategoryScreen(this.category, {super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Book> _books = [];

  void initState() {
    super.initState();
    _getBookCategory();
  }

//TODO
  void _getBookCategory() async {
    var lastBooks = await BooksService().getBookCategory(widget.category);
    setState(() {
      _books = lastBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    var showProgress = _books.isEmpty;
    var listLength = showProgress ? 1 : _books.length;
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: listLength,
        itemBuilder: (context, index) {
          if (showProgress) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (showProgress) {
            return NotFoundMessage();
          }
          return ListItemBook(_books[index]);
        },
      ),
    );
  }
}

class NotFoundMessage extends StatelessWidget {
  const NotFoundMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text("Aún no tienes ningún libro en la biblioteca",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center),
      ),
    );
  }
}

class ListItemBook extends StatelessWidget {
  final Book _book;

  const ListItemBook(this._book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 170,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            _openBookDetalils(context, _book);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: _getImageFor(_book.coverUrl),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(_book.author,
                          style: Theme.of(context).textTheme.subtitle2),
                      const SizedBox(height: 15),
                      Text(_book.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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

void _openBookDetalils(BuildContext context, Book book) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookDetailsScreen(book),
    ),
  );
}
