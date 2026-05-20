import 'package:flutter/material.dart';
import 'package:dis_app/utils/constants/colors.dart';
import 'package:dis_app/utils/constants/row.dart';
import 'package:dis_app/utils/constants/success.dart';
import 'package:dis_app/utils/constants/failed.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/withdraw/withdraw_bloc.dart';
import '../../blocs/withdraw/withdraw_event.dart';
import '../../blocs/withdraw/withdraw_state.dart';

class ConfirmTransactionScreen extends StatelessWidget {
  final String amount;
  final Map<String, dynamic> bankDetails;
  final double balance;

  ConfirmTransactionScreen({
    required this.amount,
    required this.bankDetails,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WithdrawBloc, WithdrawState>(
      listener: (context, state) {
        if (!context.mounted) {
          return;
        }

        if (state is WithdrawSuccess) {
          showDialog(
            context: context,
            builder: (context) => DisSuccess(
              onClose: () => Navigator.pop(context),
            ),
          );
        } else if (state is WithdrawFailure) {
          showDialog(
            context: context,
            builder: (context) => DisFailed(
              message: state.message,
              onRetry: () => Navigator.pop(context),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is WithdrawLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirm Transaction'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Amount To Withdraw',
                          style: TextStyle(
                            color: DisColors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'IDR $amount',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: DisColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: DisColors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisBuildRow(
                          label: 'Withdraw Amount', value: 'IDR $amount'),
                      const SizedBox(height: 8),
                      DisBuildRow(
                          label: 'Withdraw To', value: bankDetails['name']),
                      const SizedBox(height: 8),
                      DisBuildRow(
                          label: 'Bank Name', value: bankDetails['bank']),
                      const SizedBox(height: 8),
                      DisBuildRow(
                        label: 'Account Number',
                        value: bankDetails['number'],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final double withdrawAmount =
                                double.tryParse(amount.replaceAll('.', '')) ??
                                    0;
                            final int availableBalance = balance.toInt();

                            if (withdrawAmount < 1000) {
                              showDialog(
                                context: context,
                                builder: (context) => DisFailed(
                                  message:
                                      "Minimum withdrawal amount is IDR 1.000.",
                                  onRetry: () => Navigator.pop(context),
                                ),
                              );
                              return;
                            }

                            if (withdrawAmount > availableBalance) {
                              showDialog(
                                context: context,
                                builder: (context) => DisFailed(
                                  message:
                                      "Insufficient balance. Please check your account.",
                                  onRetry: () => Navigator.pop(context),
                                ),
                              );
                              return;
                            }

                            context.read<WithdrawBloc>().add(
                                  WithdrawCreateEvent(
                                    bankId: bankDetails['_id'],
                                    amount: withdrawAmount,
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DisColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Withdraw Now',
                            style: TextStyle(
                              fontSize: 16,
                              color: DisColors.white,
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

  Future<bool> _simulateTransaction() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
