import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _handleTap(BuildContext context) async {
    if (item.name == "Lihat Proyek" || item.name == "Lihat Experience") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExperienceListScreen()),
      );
    } else if (item.name == "Tambah Proyek") {
      // Fitur Add Project lokal dari Tutorial 09 tetap dipertahankan.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProjectFormPage()),
      );
    } else if (item.name == "Tambah Experience") {
      // Require authentication before opening Experience Form.
      final allowed = await ensureLoggedIn(context);

      if (!allowed || !context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExperienceFormPage()),
      );
    } else if (item.name == "Logout") {
      final authState = context.read<AuthState>();

      if (!authState.isLoggedIn) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Kamu belum login.")));
        return;
      }

      String message = "Kamu berhasil logout.";

      try {
        await authState.logout();
      } on ApiException {
        message = "Kamu sudah logout secara lokal, tetapi token di server gagal dicabut.";
      } catch (_) {
        message =
            "Kamu sudah logout secara lokal, tetapi koneksi ke server gagal.";
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.indigo,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
