import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_page.dart';

class VideoDetailPage extends StatefulWidget {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;

  VideoDetailPage({required this.title, required this.videoUrl, required this.thumbnailUrl});

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  bool isPaid = false;
  String selectedNetwork = "MTN";

  // WHATSAPP CHAT
  void openChat() async {
    String phone = "256770980980"; // Your number without 0
    String msg = "Hello ZFANZ, I want ${widget.title}";
    final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(msg)}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // PAYMENT FLOW
  void startPayment() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentPage(videoTitle: widget.title)),
    );
    if (result == true) {
      setState(() => isPaid = true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment verified! You can now download"), backgroundColor: Colors.green));
    }
  }

  // DOWNLOAD
  void downloadVideo() async {
    if (!isPaid) {
      startPayment();
      return;
    }
    // TODO: Add your downloader logic here (dio / flutter_downloader)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloading ${widget.title}...")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.thumbnailUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Price: 200 UGX", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 15),

                  // PAYMENT METHODS
                  Text("Select Network:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Row(children: [Icon(Icons.phone_android), SizedBox(width:5), Text("MTN")]),
                        selected: selectedNetwork == "MTN",
                        selectedColor: Colors.yellow[700],
                        onSelected: (v) => setState(()=>selectedNetwork="MTN"),
                      ),
                      SizedBox(width: 10),
                      ChoiceChip(
                        label: Row(children: [Icon(Icons.phone_android), SizedBox(width:5), Text("Airtel")]),
                        selected: selectedNetwork == "AIRTEL",
                        selectedColor: Colors.red[300],
                        onSelected: (v) => setState(()=>selectedNetwork="AIRTEL"),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  // BUTTONS ROW
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: downloadVideo,
                          icon: Icon(isPaid? Icons.download : Icons.lock),
                          label: Text(isPaid? "DOWNLOAD" : "PAY 200 TO DOWNLOAD"),
                          style: ElevatedButton.styleFrom(backgroundColor: isPaid? Colors.green : Colors.orange, padding: EdgeInsets.symmetric(vertical: 15)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: openChat,
                    icon: Icon(Icons.chat, color: Colors.green),
                    label: Text("Chat with Seller on WhatsApp", style: TextStyle(color: Colors.green)),
                    style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 50), side: BorderSide(color: Colors.green)),
                  ),
                  SizedBox(height: 10),
                  if(isPaid) Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.green[50],
                    child: Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width:8), Text("Paid - Download Unlocked", style: TextStyle(color: Colors.green))]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
