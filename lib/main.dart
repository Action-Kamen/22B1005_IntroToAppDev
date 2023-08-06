// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primaryColor: Colors.purple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Perform login validation here
                // For simplicity, let's assume the login is successful and navigate to the home screen
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Entry> entries = [
    Entry(name: 'Salary', amount: 2000),
    Entry(name: 'Groceries', amount: -100),
    Entry(name: 'Rent', amount: -500),
    Entry(name: 'Utilities', amount: -200),
  ];

  String category = '';
  double price = 0.0;
  bool showEntries = false;

  @override
  Widget build(BuildContext context) {
    double totalAmount = entries.map((entry) => entry.amount).fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.deepPurple, // Set the background color to deep purple
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.account_circle, size: 60, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome Back',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  showEntries = !showEntries;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          showEntries
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (showEntries)
              ...entries.map((entry) => EntryItem(entry: entry, onDelete: _deleteEntry)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddEntryDialog(
              onAdd: (name, amount) {
                setState(() {
                  entries.add(Entry(name: name, amount: amount));
                });
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteEntry(Entry entry) {
    setState(() {
      entries.remove(entry);
    });
  }
}

class Entry {
  final String name;
  final double amount;

  Entry({required this.name, required this.amount});
}

class EntryItem extends StatelessWidget {
  final Entry entry;
  final Function(Entry) onDelete;

  EntryItem({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            entry.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            '${entry.amount >= 0 ? '+' : '-'} \$${entry.amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: entry.amount >= 0 ? Colors.green : Colors.red,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Entry'),
                  content: Text('Are you sure you want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete(entry);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AddEntryDialog extends StatefulWidget {
  final Function(String, double) onAdd;

  AddEntryDialog({required this.onAdd});

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          SizedBox(height: 12),
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            double amount = double.tryParse(amountController.text) ?? 0.0;
            widget.onAdd(name, amount);
            Navigator.pop(context);
          },
          child: Text('Add Entry'),
        ),
      ],
    );
  }
}
