import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Not sıralama seçenekleri
enum NotesSortOption {
  /// Son düzenlenene göre (Yeni → Eski)
  dateModified,

  /// Oluşturulma tarihine göre (Eski → Yeni)
  dateCreated,

  /// Başlığa göre (A → Z)
  titleAZ,

  /// Başlığa göre (Z → A)
  titleZA;

  /// Kullanıcı dostu etiket
  String label(BuildContext context) {
    switch (this) {
      case NotesSortOption.dateModified:
        return 'sort.dateModified'.tr();
      case NotesSortOption.dateCreated:
        return 'sort.dateCreated'.tr();
      case NotesSortOption.titleAZ:
        return 'sort.titleAZ'.tr();
      case NotesSortOption.titleZA:
        return 'sort.titleZA'.tr();
    }
  }

  /// Açıklama metni
  String description(BuildContext context) {
    switch (this) {
      case NotesSortOption.dateModified:
        return 'sort.dateModifiedDesc'.tr();
      case NotesSortOption.dateCreated:
        return 'sort.dateCreatedDesc'.tr();
      case NotesSortOption.titleAZ:
        return 'sort.titleAZDesc'.tr();
      case NotesSortOption.titleZA:
        return 'sort.titleZADesc'.tr();
    }
  }
}
