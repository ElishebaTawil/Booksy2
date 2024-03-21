import 'package:flutter_bloc/flutter_bloc.dart';

class BookShelfState {
  List<String> bookIds;
  BookShelfState(this.bookIds);
}

abstract class BookShelfEvent {
  const BookShelfEvent();
}

class AddBookToBookShelf extends BookShelfEvent {
  final String bookid;
  const AddBookToBookShelf(this.bookid);
}

class RemoveBookFromBookShelf extends BookShelfEvent {
  final String bookid;
  const RemoveBookFromBookShelf(this.bookid);
}

class BookShelfBloc extends Bloc<BookShelfEvent, BookShelfState> {
  BookShelfBloc(BookShelfState initialState) : super(initialState) {
    on<AddBookToBookShelf>((event, emit) {
      state.bookIds.add(event.bookid);
      emit(BookShelfState(state.bookIds));
    });
    on<RemoveBookFromBookShelf>((event, emit) {
      state.bookIds.remove(event.bookid);
      emit(BookShelfState(state.bookIds));
    });
  }
}
