import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    return date.toLocal().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experience Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (experience.thumbnail.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  experience.thumbnail,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 180,
                      child: Center(child: Icon(Icons.broken_image, size: 48)),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            Text(
              experience.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              experience.categoryDisplay.isNotEmpty
                  ? experience.categoryDisplay
                  : experience.category,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 16),

            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(experience.description),

            const SizedBox(height: 20),

            const Text(
              'Experience Period',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Started: ${_formatDate(experience.startedAt)}'),
            Text(
              experience.isOngoing
                  ? 'Status: Ongoing'
                  : 'Ended: ${_formatDate(experience.endedAt)}',
            ),

            const SizedBox(height: 20),

            const Text(
              'Community',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Stars: ${experience.starCount}'),
            Text(
              experience.isStarred
                  ? 'You starred this experience.'
                  : 'You have not starred this experience.',
            ),
            if (experience.starredByNames.isNotEmpty)
              Text('Starred by: ${experience.starredByNames}'),
          ],
        ),
      ),
    );
  }
}
