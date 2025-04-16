import 'package:flutter/material.dart';
import 'package:halkhata/widgets/custom_app_bar.dart';
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
            onAddPressed: () => _showAddLoanDialog(true),
            onItemPressed: (index) =>
                _showLoanDetails(loansReceived[index], true, index),
          ),

          // Loans Given Section
          LoanSection(
            title: 'ঋণ দিয়েছি',
            loansList: loansGiven,
            iconData: Icons.arrow_upward,
            iconColor: Colors.green,
            onAddPressed: () => _showAddLoanDialog(false),
            onItemPressed: (index) =>
                _showLoanDetails(loansGiven[index], false, index),
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
                      isReceived ? 'কিস্তি যোগ করুন' : 'নতুন ঋণ নেওয়া',
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
                if (!isReceived) ...[
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
                ],
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
                  ),
                ),
                if (!isReceived) ...[
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
                ],
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
                      if (nameController.text.isNotEmpty || isReceived) {
                        final amount =
                            double.tryParse(amountController.text) ?? 0;
                        if (amount > 0) {
                          final newLoan = LoanRecord(
                            name: isReceived ? 'Unknown' : nameController.text,
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

  void _showLoanDetails(LoanRecord loan, bool isReceived, int index) {
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
                      'ঋণ বিবরণ: ${loan.name}',
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
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'মোট পরিমাণ: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '৳${loan.amount}'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'অবশিষ্ট পরিমাণ: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '৳${loan.remainingAmount}'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'তারিখ: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: DateFormat('MM/dd/yyyy').format(loan.date)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (loan.transactions.isNotEmpty) ...[
                  const Text(
                    'লেনদেন:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loan.transactions.length,
                    itemBuilder: (context, i) {
                      final transaction = loan.transactions[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text('৳${transaction.amount}'),
                        subtitle: Text(
                            DateFormat('MM/dd/yyyy').format(transaction.date)),
                        trailing: const Text('আপনি'),
                      );
                    },
                  ),
                ],
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
                      _showAddTransactionDialog(loan, isReceived, index);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'কিস্তি যোগ করুন',
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
                    const Text(
                      'কিস্তি যোগ করুন',
                      style: TextStyle(
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
                      final amount =
                          double.tryParse(amountController.text) ?? 0;
                      if (amount > 0 && amount <= loan.remainingAmount) {
                        setState(() {
                          List<LoanRecord> targetList;
                          if (isReceived) {
                            targetList = loansReceived;
                          } else {
                            targetList = loansGiven;
                          }

                          targetList[index].transactions.add(
                                Transaction(
                                  amount: amount,
                                  date: DateTime.now(),
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
}

class LoanSection extends StatelessWidget {
  final String title;
  final List<LoanRecord> loansList;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onAddPressed;
  final Function(int) onItemPressed;

  const LoanSection({
    Key? key,
    required this.title,
    required this.loansList,
    required this.iconData,
    required this.iconColor,
    required this.onAddPressed,
    required this.onItemPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Icon(iconData, color: iconColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: onAddPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6D3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 4),
                      const Text('নতুন'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: loansList.isEmpty
                ? const Center(child: Text('কোন ঋণ নেই'))
                : ListView.builder(
                    itemCount: loansList.length,
                    itemBuilder: (context, index) {
                      final loan = loansList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(loan.name),
                          subtitle: Text(
                            'শেষ হালনাগাদ: ${DateFormat('dd এপ্রিল, yyyy').format(loan.date)}',
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: title == 'ঋণ নিয়েছি'
                                  ? Colors.blue
                                  : const Color(0xFF1B6D3D),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '৳${loan.amount} (অবশিষ্ট: ৳${loan.remainingAmount})',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () => onItemPressed(index),
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

class LoanRecord {
  final String name;
  final double amount;
  final DateTime date;
  double remainingAmount;
  final List<Transaction> transactions;

  LoanRecord({
    required this.name,
    required this.amount,
    required this.date,
    required this.remainingAmount,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];
}

class Transaction {
  final double amount;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.date,
  });
}
