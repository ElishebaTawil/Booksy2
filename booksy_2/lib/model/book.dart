class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String coverUrl;

  const Book(this.id, this.title, this.author, this.category, this.description,
      this.coverUrl);
  Book.fromJson(String id, Map<String, dynamic> json)
      : this(
            id,
            json["title"] as String,
            json["author"] as String,
            json["category"] as String,
            json["description"] as String,
            json["coverUrl"] as String);

  toJason() {
    //TODO
    throw UnimplementedError();
  }
}
