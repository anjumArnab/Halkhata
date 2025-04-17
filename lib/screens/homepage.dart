import 'package:flutter/material.dart';
import 'package:halkhata/models/loan_record.dart';
import 'package:halkhata/widgets/custom_app_bar.dart';
import 'package:halkhata/widgets/loan_section.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LoanRecord> loansReceived = [];
  List<LoanRecord> loansGiven = [];

  double totalReceived = 0;
  double totalGiven = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showLogout: true,
        onLogout: () {
          // handle logout
        },
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'মোট ঋণ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const Text(
                          'নিয়েছি',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '৳$totalReceived',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B6D3D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.water_drop, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'মোট ঋণ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const Text(
                          'দিয়েছি',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '৳$totalGiven',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loans Received Section
          LoanSection(
            title: 'ঋণ নিয়েছি',
            loansList: loansReceived,
            iconData: Icons.arrow_downward,
            iconColor: Colors.blue,
            addButtonColor: const Color(0xFF1B6D3D), // Green button
            onAddPressed: () => _showAddLoanDialog(true),
            onItemPressed: (index) =>
                _showAddTransactionDialog(loansReceived[index], true, index)

          ),

          // Loans Given Section
          LoanSection(
            title: 'ঋণ দিয়েছি',
            loansList: loansGiven,
            iconData: Icons.arrow_upward,
            iconColor: Colors.green,
            addButtonColor: Colors.orange, // Orange button for loans given section
            onAddPressed: () => _showAddLoanDialog(false),
            onItemPressed: (index) =>
                _showAddTransactionDialog(loansGiven[index], false, index),)
        ],
      ),
    );
  }

  void _showAddLoanDialog(bool isReceived) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF1B6D3D),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isReceived ? 'নতুন ঋণ নেওয়া' : 'নতুন ঋণ দেওয়া',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(
                  color: Color(0xFFDAA520),
                  thickness: 2,
                ),
                const SizedBox(height: 8),
                // Person's name field is needed for both loan types
                const Text('ব্যক্তির নাম'),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('পরিমাণ'),
                const SizedBox(height: 4),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('তারিখ'),
                const SizedBox(height: 4),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      dateController.text =
                          DateFormat('MM/dd/yyyy').format(date);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                // Share option appears for both loan types
                const SizedBox(height: 12),
                const Text('শেয়ার করুন (ঐচ্ছিক)'),
                const SizedBox(height: 4),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ইমেইল দিয়ে খুঁজুন',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6D3D),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        final amount =
                            double.tryParse(amountController.text) ?? 0;
                        if (amount > 0) {
                          final newLoan = LoanRecord(
                            name: nameController.text,
                            amount: amount,
                            date: DateFormat('MM/dd/yyyy')
                                .parse(dateController.text),
                            remainingAmount: amount,
                          );

                          setState(() {
                            if (isReceived) {
                              loansReceived.add(newLoan);
                              totalReceived += amount;
                            } else {
                              loansGiven.add(newLoan);
                              totalGiven += amount;
                            }
                          });

                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      'সংরক্ষণ করুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void _showAddTransactionDialog(LoanRecord loan, bool isReceived, int index) {
  final amountController = TextEditingController();
  final dateController = TextEditingController(
    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'কিস্তি যোগ করুন',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B6D3D),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('পরিমাণ'),
              const SizedBox(height: 4),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('তারিখ'),
              const SizedBox(height: 4),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    dateController.text =
                        DateFormat('MM/dd/yyyy').format(date);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6D3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    final amount =
                        double.tryParse(amountController.text) ?? 0;
                    if (amount > 0 && amount <= loan.remainingAmount) {
                      setState(() {
                        List<LoanRecord> targetList = isReceived ? loansReceived : loansGiven;

                        targetList[index].transactions.add(
                          Transaction(
                            amount: amount,
                            date: DateFormat('MM/dd/yyyy')
                              .parse(dateController.text),
                          ),
                        );

                        targetList[index].remainingAmount -= amount;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'সংরক্ষণ করুন',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
