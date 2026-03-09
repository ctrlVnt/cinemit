import 'package:flutter/material.dart' hide showDialog, AlertDialog, CircularProgressIndicator, TextButton, Column, Row, Expanded, Divider, AppBar, TextField, Scaffold;
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Card, Colors;

import '../api/requests.dart';
import '../widgets/openSheet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _movieController = TextEditingController();
  bool enabled = true;

  @override
  void dispose() {
    _cityController.dispose();
    _movieController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final city = _cityController.text.trim();
    final movie = _movieController.text.trim();
    _showLoadingDialog(context);
    setState(() {
      enabled = false;
    });

    try {
      final results = await fetchShowtimes(movie, city);
      if (!mounted) return;

      setState(() {
        enabled = true;
      });
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return buildSheet(context, results, movie);
        },
      );

    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      print(e.toString());
    } finally {
      //_cityController.clear();
      //_movieController.clear();
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Searching...'),
        content: Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          title: const Text('CineMit'),
          subtitle: const Text('Look for a movie !'),
        ),
        const Divider(),
      ],
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextField(
                placeholder: Text('Enter your city'),
                controller: _cityController,
                  features: [
                    InputFeature.leading(
                        StatedWidget.builder(
                          builder: (context, states) {
                            // Use a muted icon normally, switch to the full icon on hover
                            return Icon(Icons.location_city);
                          },
                        )
                    ),
                  ]
              ),

              const SizedBox(height: 16),

              TextField(
                placeholder: Text('Enter the film name'),
                controller: _movieController,
                  features: [
                    InputFeature.leading(
                        StatedWidget.builder(
                      builder: (context, states) {
                        // Use a muted icon normally, switch to the full icon on hover
                          return Icon(Icons.movie);
                        },
                      )
                    ),
                  ]
              ),

              const SizedBox(height: 16),

              PrimaryButton(
                onPressed: () async {
                  await _search();
                },
                shape: ButtonShape.rectangle,
                leading: Icon(Icons.search),
                child: const Text('Search'),
                enabled: enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}