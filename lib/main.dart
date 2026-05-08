import 'package:flutter/material.dart';
import 'models/tweet.dart';
import 'services/tweet_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: const TweeterApp(),
    );
  }
}

class TweeterApp extends StatefulWidget {
  const TweeterApp({super.key});
  @override
  State<TweeterApp> createState() => _TweeterAppState();
}

class _TweeterAppState extends State<TweeterApp> {
  final TweetService tweetService = TweetService();
  final TextEditingController _controller = TextEditingController();
  List<Tweet> tweets = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  // Esta función recarga la lista desde la base de datos
  void _refresh() async {
    try {
      final data = await tweetService.fetchTweets();
      setState(() {
        tweets = data;
      });
    } catch (e) {
      print("Error al cargar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tweeter - REST API Integration')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await tweetService.postTweet(_controller.text);
                _controller.clear();
                _refresh(); // Recarga después de crear
              }
            },
            child: const Text('Post Tweet'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(tweets[index].tweet),
                    subtitle: Text('ID: ${tweets[index].id}'),
                    // --- BOTÓN DE ELIMINAR ---
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Llama al servicio para borrar en Postgres
                        await tweetService.deleteTweet(tweets[index].id);
                        // Recarga la lista para que desaparezca de la pantalla
                        _refresh();
                        // Muestra una notificación
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tweet eliminado')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
