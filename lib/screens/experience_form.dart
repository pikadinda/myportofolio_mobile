import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Data formulir sesuai model Experience Django.
  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  DateTime? _endedAt;

  // Kategori mengikuti EXPERIENCE_CHOICES pada Django.
  static const Map<String, String> _experienceChoices = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // Memilih tanggal selesai pengalaman.
  Future<void> _selectEndDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 50),
    );

    if (selectedDate != null) {
      setState(() {
        _endedAt = selectedDate;
      });
    }
  }

  // Menampilkan ringkasan setelah seluruh validasi berhasil.
  void _showSummary() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Title: $_title'),
                const SizedBox(height: 8),
                Text('Description: $_description'),
                const SizedBox(height: 8),
                Text('Category: ${_experienceChoices[_category]}'),
                const SizedBox(height: 8),
                Text(
                  'Thumbnail: ${_thumbnail.isEmpty ? "Tidak diisi" : _thumbnail}',
                ),
                const SizedBox(height: 8),
                Text(
                  'End Date: ${_endedAt == null ? "Masih berlangsung" : _formatDate(_endedAt!)}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Experience Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      // Menggunakan Drawer yang sama dengan halaman lainnya.
      drawer: const LeftDrawer(),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Your Experience',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Fill in the details of your experience.'),
                const SizedBox(height: 16),

                // === Experience Title ===
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: 'Experience Title',
                      hintText: 'Enter experience title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _title = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Experience title cannot be empty!';
                      }

                      if (value.trim().length > 255) {
                        return 'Title cannot exceed 255 characters!';
                      }

                      return null;
                    },
                  ),
                ),

                // === Description ===
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe your experience...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _description = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description cannot be empty!';
                      }

                      return null;
                    },
                  ),
                ),

                // === Category ===
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: InputDecoration(
                      labelText: 'Experience Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _experienceChoices.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _category = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category!';
                      }

                      return null;
                    },
                  ),
                ),

                // === Thumbnail URL (Optional) ===
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    maxLength: 200,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Thumbnail URL (Optional)',
                      hintText: 'https://example.com/image.jpg',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _thumbnail = value;
                    },
                    validator: (value) {
                      final url = value?.trim() ?? '';

                      // Thumbnail bersifat opsional.
                      if (url.isEmpty) {
                        return null;
                      }

                      final uri = Uri.tryParse(url);

                      if (uri == null ||
                          !uri.hasScheme ||
                          ![
                            'http',
                            'https',
                            'ftp',
                            'ftps',
                          ].contains(uri.scheme.toLowerCase()) ||
                          uri.host.isEmpty) {
                        return 'Please enter a valid URL!';
                      }

                      return null;
                    },
                  ),
                ),

                // === End Date (Optional) ===
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'End Date (Optional)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _selectEndDate,
                              icon: const Icon(Icons.calendar_month),
                              label: Text(
                                _endedAt == null
                                    ? 'Select End Date'
                                    : _formatDate(_endedAt!),
                              ),
                            ),
                          ),
                          if (_endedAt != null)
                            IconButton(
                              tooltip: 'Clear date',
                              onPressed: () {
                                setState(() {
                                  _endedAt = null;
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      ),
                      if (_endedAt == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Leave empty if this experience is ongoing.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),

                // === Save Button ===
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _showSummary,
                    child: const Text(
                      'Save Experience',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
