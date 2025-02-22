import 'package:flutter/material.dart';

class OTPApprovalScreen extends StatefulWidget {
  const OTPApprovalScreen({Key? key}) : super(key: key);
  @override
  _OTPApprovalScreenState createState() => _OTPApprovalScreenState();
}

class _OTPApprovalScreenState extends State<OTPApprovalScreen> {
  final TextEditingController otpController = TextEditingController();
  List<Map<String, String>> pendingRequests = [
    {'child': 'Child1', 'device': 'Living Room Light'},
    {'child': 'Child2', 'device': 'AC'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Approval')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      print("OTP Approved: ${otpController.text}");
                    },
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      print("OTP Rejected: ${otpController.text}");
                    },
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pendingRequests.length,
                itemBuilder: (context, index) {
                  var request = pendingRequests[index];
                  return ListTile(
                    title: Text('${request['child']} - ${request['device']}'),
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
