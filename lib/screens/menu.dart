import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

// Model untuk merepresentasikan tombol menu.
class ItemHomepage {
  final String name;
  final IconData icon;

  const ItemHomepage(this.name, this.icon);
}

// Halaman utama aplikasi.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final List<ItemHomepage> items = const [
    ItemHomepage("Lihat Proyek", Icons.folder),
    ItemHomepage("Tambah Proyek", Icons.add_circle),
    ItemHomepage("Tambah Experience", Icons.work_history),
    ItemHomepage("Logout", Icons.logout),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Drawer Menu
      drawer: const LeftDrawer(),

      // Konten halaman utama
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Selamat datang di MyPortfolio Mobile!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: items.map((item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
