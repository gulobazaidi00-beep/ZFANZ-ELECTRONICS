import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZFANZ Electronics',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: VideoListPage(),
    );
  }
}

// YOUR ONLINE VIDEOS - You can add more here anytime
List<Map<String,String>> onlineVideos = [
  {
    "title": "How to Repair Phone Screen",
    "thumb": "https://via.placeholder.com/400x220.png?text=Phone+Repair",
    "trailer": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "full": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
  },
  {
    "title": "ZFANZ Solar Installation",
    "thumb": "https://via.placeholder.com/400x220.png?text=Solar+Install",
    "trailer": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "full": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
  },
];

class VideoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZFANZ ELECTRONICS - 200 UGX"), backgroundColor: Colors.orange),
      body: ListView.builder(
        itemCount: onlineVideos.length,
        itemBuilder: (c,i){
          var v = onlineVideos[i];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(v["thumb"]!, width: 80, fit: BoxFit.cover),
              title: Text(v["title"]!),
              subtitle: Text("200 UGX - Tap to Watch & Download"),
              trailing: Icon(Icons.play_circle_fill, color: Colors.orange, size: 40),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> VideoDetailPage(video: v))),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final url = Uri.parse("https://wa.me/256770980980?text=Hello%20ZFANZ");
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        label: Text("Chat Us"), icon: Icon(Icons.chat), backgroundColor: Colors.green,
      ),
    );
  }
}

class VideoDetailPage extends StatefulWidget {
  final Map<String,String> video;
  VideoDetailPage({required this.video});
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  VideoPlayerController? _controller;
  bool isPaid = false;
  bool isDownloading = false;
  String progress = "";
  String network = "MTN";

  @override
  void initState(){
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video["trailer"]!))..initialize().then((_)=>setState((){}))..setLooping(true);
  }

  void pay() async {
    String ussd = network=="MTN"? "*165*3*1*256770980980*200#" : "*185*3*1*256770980980*200#";
    await launchUrl(Uri.parse("tel:$ussd"));
    setState(()=>isPaid=true); // Will become automatic when Yo! email arrives
  }

  void downloadFull() async {
    if(!isPaid){ pay(); return; }
    setState((){ isDownloading=true; progress="Starting..."; });
    try{
      await Permission.storage.request();
      var dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/${widget.video["title"]}.mp4";
      await Dio().download(widget.video["full"]!, savePath, onReceiveProgress: (rec,total){
        setState(()=> progress="${(rec/total*100).toStringAsFixed(0)}% downloaded");
      });
      setState(()=> progress="Downloaded! Saved to $savePath");
    }catch(e){ setState(()=> progress="Error: $e"); }
    setState(()=> isDownloading=false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video["title"]!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _controller!=null && _controller!.value.isInitialized
             ? AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: VideoPlayer(_controller!))
              : Container(height:200, color: Colors.black, child: Center(child: CircularProgressIndicator())),
            Row(children: [
              IconButton(onPressed: (){ setState(()=> _controller!.value.isPlaying? _controller!.pause() : _controller!.play()); }, icon: Icon(_controller!=null && _controller!.value.isPlaying? Icons.pause : Icons.play_arrow, size: 40)),
              Text("Free Trailer (Online)"),
            ]),
            Padding(padding: EdgeInsets.all(16), child: Column(children: [
              Text("Price: 200 UGX to Download Full HD", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height:10),
              Row(children: [
                ChoiceChip(label: Text("MTN"), selected: network=="MTN", onSelected: (v)=>setState(()=>network="MTN")),
                SizedBox(width:10),
                ChoiceChip(label: Text("Airtel"), selected: network=="AIRTEL", onSelected: (v)=>setState(()=>network="AIRTEL")),
              ]),
              SizedBox(height:20),
              ElevatedButton.icon(
                onPressed: downloadFull,
                icon: Icon(isPaid? Icons.download : Icons.lock),
                label: Text(isPaid? (isDownloading? progress : "DOWNLOAD FULL VIDEO") : "PAY 200 UGX TO DOWNLOAD"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: isPaid? Colors.green: Colors.orange),
              ),
              if(isDownloading) LinearProgressIndicator(),
              Text(progress, style: TextStyle(color: Colors.green)),
              SizedBox(height:10),
              OutlinedButton.icon(
                onPressed: () async {
                  final url = Uri.parse("https://wa.me/256770980980?text=I%20want%20${widget.video["title"]}");
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                icon: Icon(Icons.chat), label: Text("Chat Seller on WhatsApp"),
                style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
