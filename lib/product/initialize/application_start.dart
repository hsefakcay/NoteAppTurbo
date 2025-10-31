import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app_turbo/firebase_options.dart';

import '../constants/app_constants.dart';
import '../models/note.dart';
import '../../core/di/service_locator.dart';

@immutable
class ApplicationStart {
  const ApplicationStart._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // .env yükle (varsa)
    try {
      await dotenv.load(fileName: 'assets/env/.env');
    } catch (_) {}

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Opsiyonel: Firebase Auth emulator
    final useEmulator =
        (dotenv.maybeGet('USE_FIREBASE_EMULATOR') ?? 'false').toLowerCase() == 'true';
    if (useEmulator) {
      final host = dotenv.maybeGet('FIREBASE_EMULATOR_HOST') ?? 'localhost';
      final port = int.tryParse(dotenv.maybeGet('FIREBASE_AUTH_EMULATOR_PORT') ?? '9099') ?? 9099;
      await FirebaseAuth.instance.useAuthEmulator(host, port);
    }

    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NoteAdapter());
    }
    await Hive.openBox<Note>(AppConstants.notesBox);

    await setupServiceLocator();
  }
}
