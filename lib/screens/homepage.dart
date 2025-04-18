import 'package:flutter/material.dart';
import 'package:halkhata/models/loan_record.dart';
import 'package:halkhata/widgets/custom_app_bar.dart';
import 'package:halkhata/widgets/installment_dialog.dart';
import 'package:halkhata/widgets/loan_dialog.dart';
import 'package:halkhata/widgets/loan_section.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<LoanRecord> loansReceived = [];
  List<LoanRecord> loansGiven = [];

  double totalReceived = 0;
  double totalGiven = 0;

  // Add TabController
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

          // Add TabBar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF1B6D3D),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1B6D3D),
              tabs: const [
                Tab(
                  icon: Icon(Icons.arrow_downward),
                  text: 'ঋণ নিয়েছি',
                ),
                Tab(
                  icon: Icon(Icons.arrow_upward),
                  text: 'ঋণ দিয়েছি',
                ),
              ],
            ),
          ),

          // Add TabBarView with LoanSections
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Loans Received Tab
                LoanSection(
                  title: 'ঋণ নিয়েছি',
                  loansList: loansReceived,
                  iconData: Icons.arrow_downward,
                  iconColor: Colors.blue,
                  addButtonColor: const Color(0xFF1B6D3D), // Green button
                  onAddPressed: () => _showAddLoanDialog(true),
                  onItemPressed: (index) => _showAddTransactionDialog(
                      loansReceived[index], true, index),
                ),

                // Loans Given Tab
                LoanSection(
                  title: 'ঋণ দিয়েছি',
                  loansList: loansGiven,
                  iconData: Icons.arrow_upward,
                  iconColor: Colors.green,
                  addButtonColor:
                      Colors.orange, // Orange button for loans given section
                  onAddPressed: () => _showAddLoanDialog(false),
                  onItemPressed: (index) => _showAddTransactionDialog(
                      loansGiven[index], false, index),
                ),
              ],
            ),
          ),
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
    final shareController = TextEditingController();

    // Call the LoanDialog.show method
    LoanDialog.show(
      context: context,
      isReceived: isReceived,
      nameController: nameController,
      amountController: amountController,
      dateController: dateController,
      shareController: shareController,
    ).then((_) {
      if (nameController.text.isNotEmpty) {
        final amount = double.tryParse(amountController.text) ?? 0;
        if (amount > 0) {
          final newLoan = LoanRecord(
            name: nameController.text,
            amount: amount,
            date: DateFormat('MM/dd/yyyy').parse(dateController.text),
            remainingAmount: amount,
          );

          setState(() {
            if (isReceived) {
              loansReceived.add(newLoan);
              totalReceived += amount;
              // Switch to the first tab when adding a received loan
              _tabController.animateTo(0);
            } else {
              loansGiven.add(newLoan);
              totalGiven += amount;
              // Switch to the second tab when adding a given loan
              _tabController.animateTo(1);
            }
          });
        }
      }
    });
  }

  void _showAddTransactionDialog(LoanRecord loan, bool isReceived, int index) {
    final amountController = TextEditingController();
    final dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );

    InstallmentDialog.show(
      context: context,
      isReceived: isReceived,
      amountController: amountController,
      dateController: dateController,
    ).then((_) {
      final amount = double.tryParse(amountController.text) ?? 0;
      if (amount > 0 && amount <= loan.remainingAmount) {
        setState(() {
          List<LoanRecord> targetList = isReceived ? loansReceived : loansGiven;

          targetList[index].transactions.add(
                Transaction(
                  amount: amount,
                  date: DateFormat('MM/dd/yyyy').parse(dateController.text),
                ),
              );

          targetList[index].remainingAmount -= amount;
        });
      }
    });
  }
}
