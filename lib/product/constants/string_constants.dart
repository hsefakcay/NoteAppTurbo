import 'package:flutter/material.dart';

@immutable
class StringConstants {
  const StringConstants._();

  // App
  static const String appName = 'Note App Turbo';

  // Auth
  static const String login = 'Giriş';
  static const String register = 'Kayıt Ol';
  static const String email = 'Email';
  static const String password = 'Şifre';
  static const String dontHaveAccount = 'Hesabın yok mu? Kayıt ol';
  static const String haveAccount = 'Hesabın var mı? Giriş yap';

  // Home / Notes
  static const String notes = 'Notlar';
  static const String searchHint = 'Ara (başlık/içerik)';
  static const String noNotes = 'Henüz not yok';
  static const String newNote = 'Yeni Not';
  static const String editNote = 'Notu Düzenle';
  static const String title = 'Başlık';
  static const String content = 'İçerik';
  static const String pinToTop = 'Üste Sabitle';
  static const String save = 'Kaydet';
  static const String cancel = 'İptal';
  static const String deleted = 'Silindi';
  static const String undo = 'Geri Al';

  // Validations
  static const String requiredEmail = 'Email gerekli';
  static const String requiredPassword = 'Şifre gerekli';
  static const String requiredTitle = 'Başlık gerekli';
  static const String requiredContent = 'İçerik gerekli';
}
