import 'package:dis_app/pages/withdraw/withdrawal_amount.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dis_app/utils/constants/colors.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final List<Map<String, dynamic>> bankAccounts = [
    {
      'accountNumber': '901803692999',
      'name': 'KAMALA HARRIS',
      'bank': 'SEABANK',
      'balance': 150000,
    },
    {
      'accountNumber': '202503692999',
      'name': 'KAMALA HARRIS',
      'bank': 'Bank Syariah Indonesia (BSI)',
      'balance': 200000,
    },
    {
      'accountNumber': '7651803692999',
      'name': 'KAMALA HARRIS',
      'bank': 'Bank Mandiri',
      'balance': 300000,
    },
    {
      'accountNumber': '901803692999',
      'name': 'KAMALA HARRIS',
      'bank': 'Bank Central Asia (BCA)',
      'balance': 250000,
    },
    {
      'accountNumber': '777803692999',
      'name': 'KAMALA HARRIS',
      'bank': 'Bank Rakyat Indonesia (BRI)',
      'balance': 100000,
    },
  ];

  final TextEditingController _withdrawalController = TextEditingController();
  Map<String, dynamic>? selectedBank;
  String availableBalance = "IDR 0";
  int currentBalance = 0;
  bool showWarning = true;

  void selectBank(Map<String, dynamic> bank) {
    setState(() {
      selectedBank = bank;
      currentBalance = bank['balance'] ?? 0; // Ambil saldo dari bank
      availableBalance =
          'IDR ${NumberFormat.decimalPattern("id").format(currentBalance)}';
      _withdrawalController.clear(); // Bersihkan input saat memilih bank
      showWarning = currentBalance <= 0;
    });
  }

  void _onWithdrawalChanged(String value) {
    final numericValue = value.replaceAll('.', ''); // Hapus separator
    final parsedValue = int.tryParse(numericValue) ?? 0; // Parse angka

    setState(() {
      // Format ulang angka yang diinput
      _withdrawalController.text =
          NumberFormat.decimalPattern('id').format(parsedValue);
      _withdrawalController.selection = TextSelection.fromPosition(
        TextPosition(offset: _withdrawalController.text.length),
      );

      // Validasi apakah saldo mencukupi
      if (parsedValue > 0 && parsedValue <= currentBalance) {
        availableBalance =
            'IDR ${NumberFormat.decimalPattern("id").format(currentBalance - parsedValue)}';
        showWarning = false;
      } else {
        availableBalance =
            'IDR ${NumberFormat.decimalPattern("id").format(currentBalance)}';
        showWarning = parsedValue > currentBalance;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showWarning)
              Container(
                padding: const EdgeInsets.all(12.0),
                color: Colors.red.shade100,
                child: Row(
                  children: [
                    const Icon(Icons.info, color: DisColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sorry your balance is not enough to do a withdraw',
                        style: const TextStyle(color: DisColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Account Info:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: DisColors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bank Account:', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      _showBankList(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedBank == null
                              ? 'No Bank Account'
                              : '${selectedBank!['bank']} - ${selectedBank!['accountNumber']}',
                          style: TextStyle(
                            color: selectedBank == null
                                ? DisColors.grey
                                : DisColors.black,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: DisColors.primary),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Text('Available Balance',
                      style: TextStyle(fontSize: 14)),
                  Text(availableBalance,
                      style: const TextStyle(color: DisColors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Withdrawal Amount:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _withdrawalController,
              onChanged: _onWithdrawalChanged,
              decoration: InputDecoration(
                prefixText: 'IDR ',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: currentBalance > 0 &&
                        _withdrawalController.text.isNotEmpty &&
                        selectedBank != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmTransactionScreen(
                              amount: _withdrawalController.text,
                              bankDetails: selectedBank!,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentBalance > 0 && selectedBank != null
                      ? DisColors.primary
                      : Colors.grey.shade300,
                  foregroundColor: DisColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown, // Pastikan teks menyesuaikan
                  child: Text('Withdraw', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBankList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: bankAccounts.length,
          itemBuilder: (context, index) {
            final account = bankAccounts[index];
            return ListTile(
              title: Text(account['bank']!),
              subtitle: Text(account['accountNumber']!),
              onTap: () {
                selectBank(account);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}