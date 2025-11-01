/// DateTime için extension metodları
extension DateTimeExtensions on DateTime {
  /// Tarihi kullanıcı dostu formatta gösterir
  /// Örnek: "5 dk önce", "2 sa önce", "Dün", "3 gün önce", "15/10/2023"
  String toRelativeTime() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) {
          return 'Şimdi';
        }
        return '${diff.inMinutes} dk önce';
      }
      return '${diff.inHours} sa önce';
    } else if (diff.inDays == 1) {
      return 'Dün';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} gün önce';
    } else {
      return '$day/$month/$year';
    }
  }
}
