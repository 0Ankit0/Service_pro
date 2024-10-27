import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:service_pro_user/UI/Request/payment/banking.dart';
import 'package:service_pro_user/UI/Request/payment/wallet_payment.dart';

class KhaltiExampleApp extends StatelessWidget {
  const KhaltiExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Khalti Payment'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Wallet Payment'),
              // Tab(text: 'EBanking'),
              // Tab(text: 'MBanking'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WalletPayment(),
            // Banking(paymentType: PaymentType.eBanking),
            // Banking(paymentType: PaymentType.mobileCheckout),
          ],
        ),
      ),
    );
  }
}
