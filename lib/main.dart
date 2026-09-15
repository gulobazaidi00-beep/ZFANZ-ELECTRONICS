import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const String APP_NAME = "ZFANZ ELECTRONICS";
const String CHANNEL_URL = "https://youtube.com/@gulobazaidi-s7f?si=HaTPHOkgfCCtQ4uq";
const String PHONE_1 = "+256770980980";
const String PHONE_2 = "+256731008075";

List<Map<String, String>> shortsFeed = [
  {"id": "mbFpyayAD4Y", "title": "ZFANZ ELECTRONICS - New Drop 🔥 #shorts"},
  {"id": "mbFpyayAD4Y", "title": "Accessories & Repairs Tips"},
];

void main() => runApp(ZfanzApp());

class ZfanzApp extends StatelessWidget {
  @override Widget build(BuildContext c) => MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black, primaryColor: Color(0xFFFF6A00)), home: MainNav());
}
class MainNav extends StatefulWidget { @override State<MainNav> createState()=> _MainNavState(); }
class _MainNavState extends State<MainNav> {
  int cur=0;
  final pages=[HomePage(), ShortsPage(), ShopPage()];
  @override Widget build(BuildContext context)=>Scaffold(body: pages[cur], bottomNavigationBar: BottomNavigationBar(currentIndex: cur, onTap: (i)=>setState(()=>cur=i), selectedItemColor: Color(0xFFFF6A00), items: [BottomNavigationBarItem(icon: Icon(Icons.video_library), label: "Videos"), BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: "Shorts"), BottomNavigationBarItem(icon: Icon(Icons.store), label: "ZFANZ")]));
}
class HomePage extends StatelessWidget {
  final videos=[{"title":"ZFANZ ELECTRONICS - Latest","videoId":"mbFpyayAD4Y"}];
  @override Widget build(BuildContext context)=>Scaffold(appBar: AppBar(title: Text(APP_NAME, style: TextStyle(color: Color(0xFFFF6A00))), backgroundColor: Colors.black), body: ListView.builder(itemCount: videos.length, itemBuilder: (c,i){var v=videos[i]; return Card(color: Color(0xFF1A1A1A), margin: EdgeInsets.all(10), child: ListTile(leading: Image.network("https://img.youtube.com/vi/${v['videoId']}/hqdefault.jpg", width: 100, fit: BoxFit.cover), title: Text(v['title']!), subtitle: Text("Tap to watch"), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> Player(v: v)))));}));
}
class Player extends StatefulWidget { final Map v; Player({required this.v}); @override State<Player> createState()=> _PState(); }
class _PState extends State<Player>{ late YoutubePlayerController _c; @override void initState(){_c=YoutubePlayerController(initialVideoId: widget.v['videoId'], flags: YoutubePlayerFlags(autoPlay: true)); super.initState();} @override Widget build(BuildContext c)=>Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text(widget.v['title'])), body: YoutubePlayer(controller: _c));}
class ShortsPage extends StatefulWidget { @override State<ShortsPage> createState()=> _SState(); }
class _SState extends State<ShortsPage>{ int cur=0; @override Widget build(BuildContext c)=>Scaffold(backgroundColor: Colors.black, body: PageView.builder(scrollDirection: Axis.vertical, itemCount: shortsFeed.length, onPageChanged: (i)=>setState(()=>cur=i), itemBuilder: (c,i)=>ShortTile(video: shortsFeed[i], active: cur==i))); }
class ShortTile extends StatefulWidget { final Map<String,String> video; final bool active; ShortTile({required this.video, required this.active}); @override State<ShortTile> createState()=> _STState(); }
class _STState extends State<ShortTile>{ late YoutubePlayerController _c; @override void initState(){_c=YoutubePlayerController(initialVideoId: widget.video['id']!, flags: YoutubePlayerFlags(autoPlay: true, loop: true, hideControls: true)); super.initState();} @override void didUpdateWidget(old){super.didUpdateWidget(old); if(widget.active) _c.play(); else _c.pause();} @override Widget build(BuildContext c)=>Stack(children:[Center(child: YoutubePlayer(controller: _c, aspectRatio: 9/16)), Positioned(left: 12, bottom: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(APP_NAME, style: TextStyle(color: Color(0xFFFF6A00), fontWeight: FontWeight.bold)), Text(widget.video['title']!, style: TextStyle(fontSize:14)), SizedBox(height:8), Row(children:[ElevatedButton.icon(icon: Icon(Icons.call), label: Text("Call"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6A00)), onPressed: () async => await launchUrl(Uri.parse("tel:$PHONE_1"))), SizedBox(width:8), ElevatedButton(onPressed: () async => await launchUrl(Uri.parse(CHANNEL_URL), mode: LaunchMode.externalApplication), child: Text("Subscribe"))])]))]);}
class ShopPage extends StatelessWidget { @override Widget build(BuildContext c)=>Scaffold(appBar: AppBar(title: Text(APP_NAME), backgroundColor: Colors.black), body: ListView(padding: EdgeInsets.all(20), children:[Center(child: Image.asset('assets/logo.png', width: 120, errorBuilder: (_,__,___)=>Icon(Icons.store, size:80, color: Color(0xFFFF6A00)))), Center(child: Text(APP_NAME, style: TextStyle(fontSize:22, fontWeight: FontWeight.bold, color: Color(0xFFFF6A00)))), Center(child: Text("Accessories & repairs\nTrust us for your services", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))), SizedBox(height:20), Card(child: ListTile(leading: Icon(Icons.phone, color: Colors.green), title: Text(PHONE_1), onTap: () async => await launchUrl(Uri.parse("tel:$PHONE_1")))), Card(child: ListTile(leading: Icon(Icons.phone, color: Colors.green), title: Text(PHONE_2), onTap: () async => await launchUrl(Uri.parse("tel:$PHONE_2")))), Card(child: ListTile(leading: Icon(Icons.youtube_searched_for, color: Colors.red), title: Text("@gulobazaidi-s7f"), onTap: () async => await launchUrl(Uri.parse(CHANNEL_URL), mode: LaunchMode.externalApplication))),]));}
