import "dart:io";
import "package:booksy_2/model/book.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:cross_file/src/types/interface.dart";
import "package:flutter/material.dart";
import "package:flutter/src/widgets/editable_text.dart";
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

  Future<String> saveBook(String title, String author, String category,
      String description, String coverUrl) async {
    var reference = FirebaseFirestore.instance.collection("books");
    var result = await reference.add({
      "title": title,
      "author": author,
      "category": category,
      "description": description,
      "coverUrl": coverUrl,
    });
    return Future.value(result.id);
  }

  Future<String> uploadCover(String imagePath, String newBookId) async {
    try {
      var newBookRef = "books/$newBookId.png";
      File image = File(imagePath);
      var task = await firebase_storage.FirebaseStorage.instance
          .ref(newBookRef)
          .putFile(image);

      return firebase_storage.FirebaseStorage.instance
          .ref(newBookRef)
          .getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  Future<void> updateCoverBook(String newBookId, String imageUrl) async {
    var reference =
        FirebaseFirestore.instance.collection("books").doc(newBookId);
    return reference.update({
      'coverUrl': imageUrl,
    });
  }
}
