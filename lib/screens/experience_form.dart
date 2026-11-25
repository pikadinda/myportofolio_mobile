import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  DateTime? _endedAt;

  bool _isSubmitting = false;

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

  Future<void> _selectEndDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 50),
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _endedAt = selectedDate;
      });
    }
  }

  Future<void> _showSummary(Experience experience) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ${experience.id ?? "-"}'),
                const SizedBox(height: 8),
                Text('Title: ${experience.title}'),
                const SizedBox(height: 8),
                Text('Description: ${experience.description}'),
                const SizedBox(height: 8),
                Text(
                  'Category: ${experience.categoryDisplay.isNotEmpty ? experience.categoryDisplay : _experienceChoices[experience.category]}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Thumbnail: ${experience.thumbnail.isEmpty ? "Tidak diisi" : experience.thumbnail}',
                ),
                const SizedBox(height: 8),
                Text(
                  'End Date: ${experience.isOngoing || experience.endedAt == null ? "Masih berlangsung" : _formatDate(experience.endedAt!)}',
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

  Future<void> _submit() async {
    // Validate all form inputs first.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Require authentication before submitting.
    final allowed = await ensureLoggedIn(context);

    if (!allowed || !mounted) {
      return;
    }

    final authState = context.read<AuthState>();
    final token = authState.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in before adding an experience.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create a new Experience object from form inputs.
      final newExperience = Experience(
        title: _title.trim(),
        description: _description.trim(),
        category: _category,
        thumbnail: _thumbnail.trim(),
        endedAt: _endedAt,
      );

      // Send the POST request to Django using token authentication.
      final createdExperience = await context
          .read<ApiClient>()
          .createExperience(newExperience, token: token);

      if (!mounted) return;

      // Show confirmation only after the server successfully creates it.
      await _showSummary(createdExperience);
    } on ApiException catch (error) {
      if (!mounted) return;

      if (error.statusCode == 401) {
        // Clear the expired local session and request login again.
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          // AuthState clears the local token in its finally block.
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Your session has expired. Please log in again, then retry.',
            ),
          ),
        );

        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save experience (HTTP ${error.statusCode}).',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while connecting to the server.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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

                // Experience Title
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

                // Description
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

                // Category
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

                // Thumbnail URL (Optional)
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

                // End Date (Optional)
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
                              onPressed: _isSubmitting ? null : _selectEndDate,
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
                              onPressed: _isSubmitting
                                  ? null
                                  : () {
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

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
