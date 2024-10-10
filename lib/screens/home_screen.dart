import 'package:accout/provider/transaction_provider.dart';
import 'package:accout/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  get formattedProducts => null;

  // Function to adjust to Thailand time
  DateTime convertToThailandTime(DateTime dateTime) {
    return dateTime.toUtc().add(const Duration(hours: 7));
  }

  // Mapping of game titles to their respective image URLs
  final Map<String, String> gameImages = {
    'hsr':
        'https://play-lh.googleusercontent.com/cM6aszB0SawZNoAIPvtvy4xsfeFi5iXVBhZB57o-EGPWqE4pbyIUlKJzmdkH8hytuuQ', // Replace with actual URL
    'valorant':
        'https://static-00.iconduck.com/assets.00/games-valorant-icon-512x512-kqz6q7jw.png',
    'lol':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2g8YmMcaUKbwC-y2IuuXRmjriZ4PMrdr9qw&s' // Replace with actual URL
    // Add more mappings as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("ID Game Account"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop(); // Exit the app when clicked
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.transactions.isEmpty) {
            return const Center(
              child: Text('ไม่มีรายการ'), // No transactions message in Thai
            );
          } else {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                var statement = provider.transactions[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    title: Text(
                        '${statement.title} (${statement.user})'), // Display game name or title
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy HH:mm:ss').format(
                            convertToThailandTime(statement.date),
                          ),
                        ),
                        Text(
                          'รายการที่สั่งซื้อ: ${statement.products ?? "ไม่มีรายการ"}', // Show the product details
                          style: TextStyle(
                              color: statement.products != null
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                      ],
                    ),

                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          gameImages[statement.title.toLowerCase()] ??
                              'https://via.placeholder.com/60', // Default image if not found
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error, // Error icon if image fails
                              size: 30,
                            );
                          },
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (statement.keyID != null) {
                          provider.deleteTransaction(
                              statement.keyID!); // Ensure keyID is non-null
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditScreen(statement: statement);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
