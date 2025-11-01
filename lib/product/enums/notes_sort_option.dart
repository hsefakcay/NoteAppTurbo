/// Not sıralama seçenekleri
enum NotesSortOption {
  /// Son düzenlenene göre (Yeni → Eski)
  dateModified('Son düzenleme', 'Önce en son düzenlenenler'),

  /// Oluşturulma tarihine göre (Eski → Yeni)
  dateCreated('Tarih (Eski → Yeni)', 'Önce en eski notlar'),

  /// Başlığa göre (A → Z)
  titleAZ('Başlık (A-Z)', 'Alfabetik sıralama'),

  /// Başlığa göre (Z → A)
  titleZA('Başlık (Z-A)', 'Ters alfabetik sıralama');

  const NotesSortOption(this.label, this.description);

  /// Kullanıcı dostu etiket
  final String label;

  /// Açıklama metni
  final String description;
}
