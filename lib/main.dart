import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() => runApp(MaterialApp(home: GuloBazaidiApp(), debugShowCheckedModeBanner: false));

class GuloBazaidiApp extends StatefulWidget {
  @override
  State<GuloBazaidiApp> createState() => _GuloBazaidiAppState();
}

class _GuloBazaidiAppState extends State<GuloBazaidiApp> {
  List<String> videoIds = [];
  bool loading = true;
  // YOUR CHANNEL
  String channelHandle = "@gulobazaidi-s7f";

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      // Get your channel page
      final url = Uri.parse('https://www.youtube.com/$channelHandle/videos');
      final res = await http.get(url, headers: {'User-Agent': 'Mozilla/5.0'});
      final body = res.body;

      // Extract all video IDs from page
      RegExp reg = RegExp(r'"videoId":"([a-zA-Z0-9_-]{11})"');
      var matches = reg.allMatches(body).map((m) => m.group(1)!).toSet().toList();

      setState(() {
        videoIds = matches;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZFANZ-ELECTRONICS - $channelHandle"), backgroundColor: Colors.red),
      body: loading
         ? Center(child: CircularProgressIndicator())
          : videoIds.isEmpty
             ? Center(child: Text("No videos found. Check internet"))
              : ListView.builder(
                  itemCount: videoIds.length,
                  itemBuilder: (c, i) {
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network('https://img.youtube.com/vi/${videoIds[i]}/0.jpg', width: 100, fit: BoxFit.cover),
                        title: Text("Video ${i+1}"),
                        subtitle: Text(videoIds[i]),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen(videoId: videoIds[i]))),
                      ),
                    );
                  },
                ),
    );
  }
}

class PlayScreen extends StatefulWidget {
  final String videoId;
  PlayScreen({required this.videoId});
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(autoPlay: true),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZFANZ-ELECTRONICS")),
      body: Column(
        children: [
          YoutubePlayer(controller: _controller),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.chat),
            label: Text("Get Full Video - 200 UGX - WhatsApp"),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
