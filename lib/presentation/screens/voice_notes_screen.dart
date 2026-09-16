import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';

class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> {
  bool _isRecording = false;

  final List<Map<String, String>> _notes = [
    {'date': 'Today, 10:45 AM', 'duration': '01:24', 'id': 'Note_8493'},
    {'date': 'Yesterday, 02:15 PM', 'duration': '00:45', 'id': 'Note_8492'},
    {'date': '24 Aug, 11:30 AM', 'duration': '02:10', 'id': 'Note_8491'},
  ];

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (!_isRecording) {
      // Mock saving
      setState(() {
        _notes.insert(0, {
          'date': 'Just now',
          'duration': '00:15',
          'id': 'Note_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Voice note saved'),
          backgroundColor: StitchTheme.complianceGreen,
        ),
      );
    }
  }

  void _playNote(String id) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing $id...'),
        backgroundColor: StitchTheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.surface,
        title: Text('Voice Notes', style: StitchTheme.titleLg.copyWith(color: StitchTheme.primary)),
        iconTheme: IconThemeData(color: StitchTheme.primary),
      ),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic_none, size: 64, color: StitchTheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text('No voice notes yet.', style: StitchTheme.titleMd.copyWith(color: StitchTheme.outline)),
                  Text('Tap record to add.', style: StitchTheme.bodyMd.copyWith(color: StitchTheme.outline)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  color: StitchTheme.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: StitchTheme.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.mic, color: StitchTheme.primary),
                    ),
                    title: Text(note['id']!, style: StitchTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text('${note['date']} • ${note['duration']}', style: StitchTheme.labelSm.copyWith(color: StitchTheme.outline)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.play_circle_fill, color: StitchTheme.primary, size: 32),
                          onPressed: () => _playNote(note['id']!),
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'share', child: Text('Share')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                          onSelected: (val) {
                            if (val == 'delete') {
                              setState(() => _notes.removeAt(index));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRecording,
        backgroundColor: _isRecording ? Colors.white : StitchTheme.error,
        child: Icon(
          _isRecording ? Icons.stop : Icons.mic,
          color: _isRecording ? StitchTheme.error : Colors.white,
        ),
      ),
      bottomSheet: _isRecording
          ? Container(
              color: StitchTheme.error.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(color: StitchTheme.error, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Text('Recording...', style: StitchTheme.titleMd.copyWith(color: StitchTheme.error, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : null,
    );
  }
}
