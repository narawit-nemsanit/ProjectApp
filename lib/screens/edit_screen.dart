import 'package:accout/models/transactions.dart';
import 'package:accout/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class EditScreen extends StatefulWidget {
  final Transactions statement;

  EditScreen({super.key, required this.statement});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final productController = TextEditingController();

  bool _obscurePassword = true; // State for password visibility

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the statement data
    titleController.text = widget.statement.title;
    amountController.text = widget.statement.amount.toString();
    userController.text = widget.statement.user;
    passwordController.text = widget.statement.password;

    // Initialize productController, check if products is null
    productController.text = widget.statement.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แบบฟอร์มข้อมูล'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Game Name',
                ),
                autofocus: false,
                controller: titleController,
                validator: (String? str) {
                  if (str == null || str.isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                controller: amountController,
                validator: (String? str) {
                  if (str == null || str.isEmpty) {
                    return 'กรุณากรอกจำนวน';
                  }
                  if (double.tryParse(str) == null) {
                    return 'กรุณากรอกจำนวนที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'รายการที่เติม',
                ),
                autofocus: false,
                controller: productController,
                validator: (String? str) {
                  if (str == null || str.isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                autofocus: false,
                controller: userController,
                validator: (String? username) {
                  if ((username ?? '').isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  if ((username ?? '').length < 3) {
                    return 'ชื่อผู้ใช้ต้องมีอย่างน้อย 3 ตัวอักษร';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                controller: passwordController,
                validator: (String? password) {
                  if (password == null || password.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('บันทึก'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    try {
                      // Update the existing transaction object
                      var statement = Transactions(
                        keyID: widget.statement.keyID, // Use the existing keyID
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                        date: DateTime.now(),
                        user: userController.text,
                        password: passwordController.text,
                        products: productController.text,
                      );

                      // Update transaction in provider
                      var provider = Provider.of<TransactionProvider>(context,
                          listen: false);
                      provider.updateTransaction(statement);

                      // Navigate back to the home page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
