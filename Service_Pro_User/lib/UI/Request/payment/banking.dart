import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Banking extends StatefulWidget {
  const Banking({Key? key, required this.paymentType}) : super(key: key);

  final PaymentType paymentType;

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BankListModel>(
      future: Khalti.service.getBanks(paymentType: widget.paymentType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final banks = snapshot.data!.banks;
          return ListView.builder(
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final bank = banks[index];

              return ListTile(
                leading: SizedBox.square(
                  dimension: 40,
                  child: Image.network(bank.logo),
                ),
                title: Text(bank.name),
                subtitle: Text(bank.shortName),
                onTap: () async {
                  final mobile = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String? mobile;
                      return AlertDialog(
                        title: const Text('Enter Mobile Number'),
                        content: TextField(
                          decoration: const InputDecoration(
                            label: Text('Mobile Number'),
                          ),
                          onChanged: (v) => mobile = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context, mobile),
                          )
                        ],
                      );
                    },
                  );

                  if (mobile != null) {
                    final url = Khalti.service.buildBankUrl(
                      bankId: bank.idx,
                      amount: 1000,
                      mobile: mobile,
                      productIdentity: 'macbook-pro-21',
                      productName: 'Macbook Pro 2021',
                      paymentType: widget.paymentType,
                      returnUrl: 'https://khalti.com',
                    );
                    url_launcher.launchUrl(Uri.parse(url));
                  }
                },
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
