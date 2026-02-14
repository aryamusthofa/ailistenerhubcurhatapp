import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language/language_provider.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (String languageCode) {
        ref.read(languageProvider.notifier).setLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Text('🇺🇸', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text('English',
                  style: TextStyle(
                    fontWeight: currentLocale.languageCode == 'en'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'id',
          child: Row(
            children: [
              Text('🇮🇩', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text('Bahasa Indonesia',
                  style: TextStyle(
                    fontWeight: currentLocale.languageCode == 'id'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
