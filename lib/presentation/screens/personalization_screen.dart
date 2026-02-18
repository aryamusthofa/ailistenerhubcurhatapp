import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_curhat_app/presentation/widgets/fx/glass_container.dart';
import 'package:ai_curhat_app/presentation/widgets/themeable_container.dart';
import '../providers/personalization_provider.dart';

class PersonalizationScreen extends ConsumerStatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  ConsumerState<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends ConsumerState<PersonalizationScreen> {
  late TextEditingController _aboutMeController;
  late TextEditingController _instructionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(personalizationProvider);
    _aboutMeController = TextEditingController(text: state.aboutMe);
    _instructionController = TextEditingController(text: state.instruction);
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalisasi AI'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: ThemeableContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildInputSection(
                  context,
                  title: 'Tentang Diri Anda',
                  subtitle: 'Apa yang AI harus tahu? (Nama, kondisi, hobi, dll)',
                  controller: _aboutMeController,
                  icon: Icons.person_outline,
                  onChanged: (val) => ref.read(personalizationProvider.notifier).updateAboutMe(val),
                ),
                const SizedBox(height: 24),
                _buildInputSection(
                  context,
                  title: 'Gaya Respon AI',
                  subtitle: 'Bagaimana AI harus merespon curhatanmu?',
                  controller: _instructionController,
                  icon: Icons.psychology_outlined,
                  onChanged: (val) => ref.read(personalizationProvider.notifier).updateInstruction(val),
                ),
                const SizedBox(height: 24),
                _buildTipsCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kenali Saya',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bantu AI memahami konteks dan kebutuhan emosionalmu.',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 4,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Ketik di sini...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      color: Colors.amber.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Tips: Semakin spesifik, semakin "nyambung" AI-nya dengan perasaanmu.',
              style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }
}
