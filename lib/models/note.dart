class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});

  Note copyWith({
    String? id,
    String? title,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
