import 'package:hive/hive.dart';

part 'sync_operation.g.dart';

/// Senkronizasyon işlem türleri
enum SyncOperationType { create, update, delete, togglePin }

/// Offline yapılan işlemleri takip etmek için model
@HiveType(typeId: 2)
class SyncOperation {
  SyncOperation({
    required this.id,
    required this.type,
    required this.noteId,
    required this.timestamp,
    this.noteData,
    this.isPinned,
  });

  /// İşlem ID'si
  @HiveField(0)
  final String id;

  /// İşlem türü
  @HiveField(1)
  final SyncOperationType type;

  /// İlgili not ID'si
  @HiveField(2)
  final String noteId;

  /// İşlem zamanı
  @HiveField(3)
  final DateTime timestamp;

  /// Not verisi (create/update için)
  @HiveField(4)
  final Map<String, dynamic>? noteData;

  /// Pin durumu (togglePin için)
  @HiveField(5)
  final bool? isPinned;

  /// JSON'a dönüştür
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'noteId': noteId,
    'timestamp': timestamp.toIso8601String(),
    if (noteData != null) 'noteData': noteData,
    if (isPinned != null) 'isPinned': isPinned,
  };

  /// JSON'dan oluştur
  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'] as String,
      type: SyncOperationType.values.firstWhere((e) => e.name == json['type']),
      noteId: json['noteId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      noteData: json['noteData'] as Map<String, dynamic>?,
      isPinned: json['isPinned'] as bool?,
    );
  }

  @override
  String toString() => 'SyncOperation(id: $id, type: $type, noteId: $noteId)';
}
