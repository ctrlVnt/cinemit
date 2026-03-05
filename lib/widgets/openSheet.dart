import 'package:flutter/material.dart' hide Column, Row, Expanded, Divider, AppBar, TextField, Scaffold, Card;
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

// Assumendo che il file si chiami showtimes.dart
import '../models/showtimes.dart';

Widget buildSheet(BuildContext context, List<Showtimes> data, String movieTitle) {
  // Funzione corretta per aprire i link
  Future<void> _handleLaunchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  return Container(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Showtimes')
                  .h3()
                  .ellipsis(),
            ),
            const CloseButton(),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: data.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final dayGroup = data[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header del Giorno
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(dayGroup.day)
                        .small()
                        .muted()
                        .semiBold(),
                  ),
                  // Lista dei Cinema per quel giorno
                  ...dayGroup.theaters.map((cinema) => Card(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(cinema.name).large().semiBold()),
                            if (cinema.distance.isNotEmpty)
                              Text(cinema.distance).xSmall().muted(),
                          ],
                        ),
                        Text(cinema.address).xSmall().muted(),
                        const SizedBox(height: 12),
                        // Bolle degli orari
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: cinema.show.expand((s) => s.time).map((t) {
                            return Badge(
                              child: Text(t),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        // Tasto per prenotare/sito
                        OutlineButton(
                          size: ButtonSize.small,
                          onPressed: () => _handleLaunchUrl(cinema.link),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("See on google"),
                              SizedBox(width: 8),
                              Icon(Icons.open_in_new, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.movie_filter, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        Text("Nessun orario trovato per questo film.")
            .muted(),
      ],
    ),
  );
}