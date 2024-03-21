import "dart:io";
import "package:booksy_2/model/book.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class BooksService {
  final booksRef = FirebaseFirestore.instance.collection("books").withConverter(
        fromFirestore: (snapshot, _) =>
            Book.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (book, _) => book.toJason(),
      );

  Future<List<Book>> getLastBook() async {
    var result = await booksRef.get().then((value) => value);
    List<Book> books = [];
    for (var doc in result.docs) {
      books.add(doc.data());
    }

    return Future.value(books);
  }

  Future<Book> getBook(String bookId) async {
    var result = await booksRef.doc(bookId).get().then((value) => value);
    if (result.exists) {
      return Future.value(result.data());
    }
    throw const HttpException("Book not found");
  }

  Future<List<Book>> getBookCategory(String bookCategory) async {
    var result = await booksRef.get().then((value) => value);
    List<Book> books = [];

    for (var doc in result.docs) {
      if (doc.data().category == bookCategory) {
        books.add(doc.data());
      }
    }
    if (books.isNotEmpty) {
      return books;
    }
    throw const HttpException("Category Empty");
  }

  //NO SE IMPLEN¿MENTO TODAVIA
  // Future<List<Book>> getBookFromTitle(String inputUser) async {
  //   List<Book> secondListBooks = books
  //       .where((bookElement) =>
  //           bookElement.title.toLowerCase().contains(inputUser.toLowerCase()))
  //       .toList();
  //   return secondListBooks;
  // }
}
