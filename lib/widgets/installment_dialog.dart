import 'package:flutter/material.dart';
import 'package:halkhata/widgets/custom_button.dart';
import 'package:halkhata/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';

extension TapToOpenDatePicker on Widget {
  Widget buildGestureDetector({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: AbsorbPointer(
        child: this,
      ),
    );
  }
}

class InstallmentDialog {
  static Future<void> show({
    required BuildContext context,
    required bool isReceived,
    required TextEditingController amountController,
    required TextEditingController dateController,
  }) {
    return showDialog(
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
            child: SingleChildScrollView(
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
                  const Text('পরিমাণ'),
                  const SizedBox(height: 4),
                  CustomTextFormField(
                    controller: amountController,
                    hintText: 'পরিমাণ লিখুন',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  const Text('তারিখ'),
                  const SizedBox(height: 4),
                  CustomTextFormField(
                    controller: dateController,
                    hintText: 'তারিখ নির্বাচন করুন',
                    suffixIcon: const Icon(Icons.calendar_today),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'তারিখ আবশ্যক';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.none,
                  ).buildGestureDetector(
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
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                      text: 'সংরক্ষণ করুন',
                      onPressed: () {
                        // Add your save logic here
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
