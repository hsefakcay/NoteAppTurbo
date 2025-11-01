import '../enums/notes_sort_option.dart';
import '../models/note.dart';

/// Not filtreleme ve sıralama servisi
/// Single Responsibility: Sadece filtreleme ve sıralama logic
class NotesSortFilterService {
  /// Notları filtrele ve sırala
  List<Note> apply({
    required List<Note> notes,
    bool showPinnedOnly = false,
    NotesSortOption sortBy = NotesSortOption.dateModified,
    String? searchQuery,
  }) {
    var result = [...notes];

    // Arama filtresi
    if (searchQuery != null && searchQuery.isNotEmpty) {
      result = _applySearch(result, searchQuery);
    }

    // Sabitle filtresi
    if (showPinnedOnly) {
      result = result.where((n) => n.pinned).toList();
    }

    // Sıralama
    result = _sort(result, sortBy);

    return result;
  }

  /// Arama filtresi uygula
  List<Note> _applySearch(List<Note> notes, String query) {
    final lower = query.toLowerCase();
    return notes
        .where(
          (n) => n.title.toLowerCase().contains(lower) || n.content.toLowerCase().contains(lower),
        )
        .toList();
  }

  /// Notları sırala
  List<Note> _sort(List<Note> notes, NotesSortOption option) {
    final copy = [...notes];

    switch (option) {
      case NotesSortOption.dateModified:
        copy.sort((a, b) {
          // Sabitlenmiş notlar her zaman üstte
          if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
          // Yeni düzenlenenler üstte
          return b.updatedAt.compareTo(a.updatedAt);
        });
        break;

      case NotesSortOption.dateCreated:
        copy.sort((a, b) {
          if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
          // Eski notlar üstte
          return a.updatedAt.compareTo(b.updatedAt);
        });
        break;

      case NotesSortOption.titleAZ:
        copy.sort((a, b) {
          if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
          // Alfabetik A-Z
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });
        break;

      case NotesSortOption.titleZA:
        copy.sort((a, b) {
          if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
          // Alfabetik Z-A
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        });
        break;
    }

    return copy;
  }

  /// Sadece sırala (filtre yok)
  List<Note> sortOnly(List<Note> notes, NotesSortOption option) {
    return _sort(notes, option);
  }

  /// Filtreleme gerekli mi kontrol et
  bool needsFiltering({
    bool showPinnedOnly = false,
    NotesSortOption sortBy = NotesSortOption.dateModified,
    String? searchQuery,
  }) {
    return showPinnedOnly ||
        sortBy != NotesSortOption.dateModified ||
        (searchQuery != null && searchQuery.isNotEmpty);
  }
}
