import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeNavigation(),
    );
  }
}

// Dados globais
List<String> listaClientes = [];
List<Map<String, String>> listaServicos = [];

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CadastroClientePage(),
    CadastroServicoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cadastro Cliente'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cadastro Serviço'),
        ],
      ),
    );
  }
}

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  int? clienteSelecionadoIndex;

  void _salvarCliente() {
    if (nomeController.text.isNotEmpty) {
      setState(() {
        listaClientes.add(nomeController.text);
        nomeController.clear();
        emailController.clear();
        telefoneController.clear();
      });
    }
  }

  void _excluirCliente() {
    if (clienteSelecionadoIndex != null) {
      setState(() {
        listaClientes.removeAt(clienteSelecionadoIndex!);
        clienteSelecionadoIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Cliente'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarCliente,
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Clientes cadastrados:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: listaClientes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listaClientes[index]),
                    tileColor: clienteSelecionadoIndex == index
                        ? Colors.deepPurple.shade100
                        : null,
                    onTap: () {
                      setState(() {
                        clienteSelecionadoIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: clienteSelecionadoIndex != null
          ? FloatingActionButton(
              onPressed: _excluirCliente,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            )
          : null,
    );
  }
}

class CadastroServicoPage extends StatefulWidget {
  const CadastroServicoPage({super.key});

  @override
  State<CadastroServicoPage> createState() => _CadastroServicoPageState();
}

class _CadastroServicoPageState extends State<CadastroServicoPage> {
  final TextEditingController nomeServicoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  String? clienteSelecionado;
  int? servicoSelecionadoIndex;

  void _salvarServico() {
    if (nomeServicoController.text.isNotEmpty &&
        clienteSelecionado != null &&
        valorController.text.isNotEmpty) {
      setState(() {
        listaServicos.add({
          'cliente': clienteSelecionado!,
          'nome': nomeServicoController.text,
          'descricao': descricaoController.text,
          'valor': valorController.text,
        });
        nomeServicoController.clear();
        descricaoController.clear();
        valorController.clear();
        clienteSelecionado = null;
      });
    }
  }

  void _excluirServico() {
    if (servicoSelecionadoIndex != null) {
      setState(() {
        listaServicos.removeAt(servicoSelecionadoIndex!);
        servicoSelecionadoIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Cliente Vinculado'),
              value: clienteSelecionado,
              items: listaClientes
                  .map((cliente) => DropdownMenuItem(
                        value: cliente,
                        child: Text(cliente),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  clienteSelecionado = value;
                });
              },
            ),
            TextField(
              controller: nomeServicoController,
              decoration: const InputDecoration(labelText: 'Nome do Serviço'),
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarServico,
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Serviços cadastrados:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: listaServicos.length,
                itemBuilder: (context, index) {
                  final servico = listaServicos[index];
                  return ListTile(
                    title: Text('${servico['nome']} - R\$${servico['valor']}'),
                    subtitle: Text(
                        'Cliente: ${servico['cliente']} \nDescrição: ${servico['descricao']}'),
                    tileColor: servicoSelecionadoIndex == index
                        ? Colors.deepPurple.shade100
                        : null,
                    onTap: () {
                      setState(() {
                        servicoSelecionadoIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: servicoSelecionadoIndex != null
          ? FloatingActionButton(
              onPressed: _excluirServico,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            )
          : null,
    );
  }
}