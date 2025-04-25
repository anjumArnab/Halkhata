import 'package:flutter/material.dart';
import 'package:halkhata/models/loan_record.dart';
import 'package:intl/intl.dart';

class LoanSection extends StatelessWidget {
  final String title;
  final List<LoanRecord> loansList;
  final IconData iconData;
  final Color iconColor;
  final Color addButtonColor;
  final VoidCallback onAddPressed;
  final GestureDragUpdateCallback? onPanUpdate;
  final void Function()? onLongPress;
  final Function(int) onItemPressed;

  const LoanSection({
    super.key,
    required this.title,
    required this.loansList,
    required this.iconData,
    required this.iconColor,
    required this.addButtonColor,
    required this.onAddPressed,
    this.onPanUpdate,
    this.onLongPress,
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
                Icon(
                  // Update icons based on section
                  title == 'ঋণ নিয়েছি' 
                    ? Icons.arrow_downward 
                    : Icons.arrow_upward,
                  color: iconColor,
                ),
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
                      backgroundColor: addButtonColor, // Use the provided color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 4),
                        Text('নতুন'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: loansList.isEmpty
                  ? const SizedBox(height: 15)
                  : ListView.builder(
                      itemCount: loansList.length,
                      itemBuilder: (context, index) {
                        final loan = loansList[index];
                        bool isPaid = loan.remainingAmount <= 0;
                        return GestureDetector(
                          onLongPress: onLongPress, // LONG PRESS TO DELETE THIS FULL CARD (HIVE DELETE OPERATION)
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        loan.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
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
                                    ],
                                  ),
                                ),
                                
                                // Display transaction history
                                if (loan.transactions!.isNotEmpty) 
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: loan.transactions!.length,
                                    itemBuilder: (context, i) {
                                      final transaction = loan.transactions![i];
                                      return GestureDetector(
                                    onPanUpdate: onPanUpdate, // RIGHT SWIPE TO DELETE THIS PARTICULAR TRANSACTION (HIVE DELETE OPERATION)
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 12),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.orange,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12, 
                                              vertical: 8
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '৳${transaction.amount}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '(${DateFormat('MM/dd/yyyy').format(transaction.date)})',
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                                const Text('আপনি'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                
                                // Date and action row
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'শেষ হালনাগাদ: ${DateFormat('dd এপ্রিল, yyyy').format(loan.date)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      isPaid 
                                        ? OutlinedButton.icon(
                                            onPressed: null,
                                            icon: const Icon(Icons.check, color: Colors.green),
                                            label: const Text(
                                              'পরিশোধিত',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.green),
                                            ),
                                          )
                                        : OutlinedButton(
                                            onPressed: () => onItemPressed(index),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: title == 'ঋণ নিয়েছি'
                                                  ? Colors.blue
                                                  : const Color(0xFF1B6D3D),
                                            ),
                                            child: const Text('কিস্তি যোগ করুন'),
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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