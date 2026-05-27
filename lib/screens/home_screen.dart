import 'package:flutter/material.dart';
import '../services/painting_service.dart';
import '../services/auth_service.dart';
import '../models/painting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PaintingService _service = PaintingService();
  final AuthService _auth = AuthService();
  final _titleCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  List<Painting> _paintings = [];

  void _refresh() async {
    try {
      final data = await _service.fetchPaintings();
      setState(() { _paintings = data; });
    } catch (e) {
      print("Error al cargar: $e");
    }
  }

  @override
  void initState() { 
    super.initState(); 
    _refresh(); 
  }

  void _showEditDialog(Painting obra) {
    _titleCtrl.text = obra.title;
    _yearCtrl.text = obra.year;
    _descCtrl.text = obra.description;
    _urlCtrl.text = obra.imageUrl;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Obra de Arte"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Título')),
              TextField(controller: _yearCtrl, decoration: const InputDecoration(labelText: 'Año')),
              TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
              TextField(controller: _urlCtrl, decoration: const InputDecoration(labelText: 'URL de la Imagen')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              await _service.updatePainting(obra.id, _titleCtrl.text, _yearCtrl.text, _descCtrl.text, _urlCtrl.text);
              Navigator.pop(context);
              _refresh();
            },
            child: const Text("Guardar Cambios"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.getUser();
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris claro para que resalten los cuadros
      appBar: AppBar(
        title: const Text('Galería de Arte Digital', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Chip(
              label: Text(user?.username ?? 'Artista', style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.white70,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Column(
        children: [
          // PANEL PARA AGREGAR NUEVAS OBRAS
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 2,
            child: ExpansionTile(
              leading: const Icon(Icons.add_photo_alternate, color: Colors.purple),
              title: const Text("Agregar nueva obra a mi colección", style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Título')),
                      TextField(controller: _yearCtrl, decoration: const InputDecoration(labelText: 'Año')),
                      TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
                      TextField(controller: _urlCtrl, decoration: const InputDecoration(labelText: 'Link de la Imagen')),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.upload),
                          label: const Text("PUBLICAR EN GALERÍA"),
                          onPressed: () async {
                            await _service.addPainting(_titleCtrl.text, _yearCtrl.text, _descCtrl.text, _urlCtrl.text);
                            _titleCtrl.clear(); _yearCtrl.clear(); _descCtrl.clear(); _urlCtrl.clear();
                            _refresh();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // LISTADO DE OBRAS
          Expanded(
            child: ListView.builder(
              itemCount: _paintings.length,
              itemBuilder: (context, index) {
                final obra = _paintings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  clipBehavior: Clip.antiAlias,
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MARCO DE LA IMAGEN (AQUÍ ES EL CAMBIO PRINCIPAL)
                      Container(
                        color: Colors.black, // Fondo negro para que la obra luzca como en un museo
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // Mantiene una proporción elegante
                          child: Image.network(
                            obra.imageUrl,
                            fit: BoxFit.contain, // MUESTRA LA IMAGEN COMPLETA SIN CORTARLA
                            errorBuilder: (context, error, stackTrace) => 
                              const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
                          ),
                        ),
                      ),
                      
                      // INFORMACIÓN DE LA OBRA
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    obra.title.toUpperCase(),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                      onPressed: () => _showEditDialog(obra),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () async {
                                        await _service.deletePainting(obra.id);
                                        _refresh();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text("Año: ${obra.year}", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                            const SizedBox(height: 10),
                            Text(obra.description, style: const TextStyle(fontSize: 15)),
                            const Divider(height: 25),
                            Row(
                              children: [
                                const Icon(Icons.person_pin, size: 16, color: Colors.purple),
                                const SizedBox(width: 5),
                                Text(
                                  "Artista: ${obra.username}", 
                                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.purple, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
