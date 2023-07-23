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
      home: HomeScreen(),
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
    double totalAmount = entries.fold(0, (sum, entry) => sum + entry.amount);
    String netAmountText = totalAmount >= 0 ? '\$$totalAmount' : '-\$${totalAmount.abs()}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.purple[100], // Set the background color to lavender purple
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!showEntries) // Show only when entries are hidden
                Column(
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey, // Replace with your profile image
                      child: Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showEntries = !showEntries;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 12),
                    Text(
                      netAmountText,
                      style: TextStyle(fontSize: 36, color: Colors.black),
                    ),
                    Icon(
                      showEntries ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              if (showEntries)
                ...entries.map(
                      (entry) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple[50], // Light purple background inside the border
                        borderRadius: BorderRadius.circular(12), // Rounded border
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${entry.name}:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          Text(
                            '${entry.amount >= 0 ? '+' : '-'}\$${entry.amount.abs().toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteEntry(entry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEntryDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple, // Set the background color to deep purple
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => category = value,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple), // Set the button color to deep purple
            ),
            ElevatedButton(
              onPressed: () {
                if (category.isNotEmpty && price != 0.0) {
                  setState(() {
                    entries.add(Entry(name: category, amount: price));
                    category = '';
                    price = 0.0;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple), // Set the button color to deep purple
            ),
          ],
        );
      },
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
