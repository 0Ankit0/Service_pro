import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';

class WalletPayment extends StatefulWidget {
  const WalletPayment({Key? key}) : super(key: key);

  @override
  State<WalletPayment> createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  late final TextEditingController _mobileController, _pinController;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: const InputDecoration(
              label: Text('Mobile Number'),
            ),
            controller: _mobileController,
          ),
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: const InputDecoration(
              label: Text('Khalti MPIN'),
            ),
            controller: _pinController,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (!(_formKey.currentState?.validate() ?? false)) return;
              final messenger = ScaffoldMessenger.maybeOf(context);
              final initiationModel = await Khalti.service.initiatePayment(
                request: PaymentInitiationRequestModel(
                  amount: 1000,
                  mobile: _mobileController.text,
                  productIdentity: 'mac-mini',
                  productName: 'Apple Mac Mini',
                  transactionPin: _pinController.text,
                  productUrl: 'https://khalti.com/bazaar/mac-mini-16-512-m1',
                  additionalData: {
                    'vendor': 'Oliz Store',
                    'manufacturer': 'Apple Inc.',
                  },
                ),
              );

              final otpCode = await _showOTPSentDialog();

              if (otpCode != null) {
                try {
                  final model = await Khalti.service.confirmPayment(
                    request: PaymentConfirmationRequestModel(
                      confirmationCode: otpCode,
                      token: initiationModel.token,
                      transactionPin: _pinController.text,
                    ),
                  );

                  debugPrint(model.toString());
                } catch (e) {
                  messenger?.showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text('PAY Rs. 10'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showOTPSentDialog() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? otp;
        return AlertDialog(
          title: const Text('OTP Sent!'),
          content: TextField(
            decoration: const InputDecoration(
              label: Text('OTP Code'),
            ),
            onChanged: (v) => otp = v,
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, otp),
            )
          ],
        );
      },
    );
  }
}
