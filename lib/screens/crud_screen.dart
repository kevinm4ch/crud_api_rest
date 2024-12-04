
import 'package:flutter/material.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<Map<String, dynamic>> _items = [];
  int _nextId = 1; // Gerador de IDs para novos itens

  // Adicionar item
  void _addItem(String name) {
    setState(() {
      _items.add({'id': _nextId++, 'name': name});
    });
    _nameController.clear();
  }

  // Editar item
  void _editItem(int id, String newName) {
    setState(() {
      final itemIndex = _items.indexWhere((item) => item['id'] == id);
      if (itemIndex != -1) {
        _items[itemIndex]['name'] = newName;
      }
    });
  }

  // Excluir item
  void _deleteItem(int id) {
    setState(() {
      _items.removeWhere((item) => item['id'] == id);
    });
  }

  // Abrir diálogo para criar ou editar
  void _showDialog({int? id, String? currentName}) {
    final isEditing = id != null;

    if (isEditing) {
      _nameController.text = currentName ?? '';
    } else {
      _nameController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Item' : 'Novo Item'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome do Item'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  if (isEditing) {
                    _editItem(id, name);
                  } else {
                    _addItem(name);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(isEditing ? 'Salvar' : 'Adicionar'),
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
        title: const Text('CRUD Simples'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showDialog(
                            id: item['id'],
                            currentName: item['name'],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItem(item['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _showDialog(),
              child: const Text('Adicionar Novo Item'),
            ),
          ],
        ),
      ),
    );
  }
}
