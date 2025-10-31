import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Note extends HiveObject with EquatableMixin {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.pinned,
    required this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final bool pinned;

  @HiveField(4)
  final DateTime updatedAt;

  Note copyWith({String? id, String? title, String? content, bool? pinned, DateTime? updatedAt}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      pinned: (json['pinned'] as bool?) ?? false,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'pinned': pinned,
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, content, pinned, updatedAt];
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final content = reader.readString();
    final pinned = reader.readBool();
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    return Note(id: id, title: title, content: content, pinned: pinned, updatedAt: updatedAt);
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.content)
      ..writeBool(obj.pinned)
      ..writeInt(obj.updatedAt.millisecondsSinceEpoch);
  }
}
