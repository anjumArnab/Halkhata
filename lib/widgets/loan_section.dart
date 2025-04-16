import 'package:flutter/material.dart';
import 'package:halkhata/models/loan_record.dart';
import 'package:intl/intl.dart';

class LoanSection extends StatelessWidget {
  final String title;
  final List<LoanRecord> loansList;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onAddPressed;
  final Function(int) onItemPressed;

  const LoanSection({
    super.key,
    required this.title,
    required this.loansList,
    required this.iconData,
    required this.iconColor,
    required this.onAddPressed,
    required this.onItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        borderRadius: BorderRadius.circular(32),
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
      ),
    );
  }
}
