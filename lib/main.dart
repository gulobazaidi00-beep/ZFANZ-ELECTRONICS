import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZFANZ Electronics',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: VideoDetailPage(
        title: "My Training Video",
        videoUrl: "https://your-video-link.mp4",
        thumbnailUrl: "https://via.placeholder.com/400x220.png?text=ZFANZ+Video",
      ),
    );
  }
}

class VideoDetailPage extends StatefulWidget {
  final String title; final String videoUrl; final String thumbnailUrl;
  VideoDetailPage({required this.title, required this.videoUrl, required this.thumbnailUrl});
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  bool isPaid = false;
  String selectedNetwork = "MTN";

  void openChat() async {
    final url = Uri.parse("https://wa.me/256770980980?text=Hello%20ZFANZ%20I%20want%20${widget.title}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void startPayment() async {
    String ussd = selectedNetwork=="MTN" ? "*165*3*1*256770980980*200#" : "*185*3*1*256770980980*200#";
    await launchUrl(Uri.parse("tel:$ussd"));
    setState(()=>isPaid=true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Image.network(widget.thumbnailUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Price: 200 UGX", style: TextStyle(color: Colors.green, fontSize: 18)),
                SizedBox(height:15),
                Row(children: [
                  ChoiceChip(label: Text("MTN"), selected: selectedNetwork=="MTN", onSelected: (v)=>setState(()=>selectedNetwork="MTN")),
                  SizedBox(width:10),
                  ChoiceChip(label: Text("Airtel"), selected: selectedNetwork=="AIRTEL", onSelected: (v)=>setState(()=>selectedNetwork="AIRTEL")),
                ]),
                SizedBox(height:20),
                ElevatedButton.icon(
                  onPressed: isPaid ? (){} : startPayment,
                  icon: Icon(isPaid? Icons.download : Icons.lock),
                  label: Text(isPaid? "DOWNLOAD NOW" : "PAY 200 UGX - $selectedNetwork"),
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: isPaid? Colors.green: Colors.orange),
                ),
                SizedBox(height:10),
                OutlinedButton.icon(
                  onPressed: openChat,
                  icon: Icon(Icons.chat, color: Colors.green),
                  label: Text("Chat Seller on WhatsApp"),
                  style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
