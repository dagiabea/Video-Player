import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player_test/model/videoListModel.dart';
import 'package:video_player_test/utils/color.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../adMob/adhelper.dart';
import '../player/land.dart';

class VideoList extends StatefulWidget {
  final ModelForVidesClass listOfVideos;
  const VideoList({Key? key, required this.listOfVideos}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      backgroundColor: widget.listOfVideos.appBackgroundHexColor.toColor(),
      appBar: AppBar(
        title: const Text('Puppies 🐾'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              shareApp();
            },
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            icon: const Icon(Icons.star_rate),
            onPressed: () {
              _showRatingDialog();
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: widget.listOfVideos.videos.isEmpty
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: widget.listOfVideos.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        leading: ClipRRect(
                          // borderRadius: const BorderRadius.all(
                          //   Radius.circular(100.0),
                          // ),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: widget.listOfVideos.videos[index].thumb,
                            imageErrorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Image(
                                image: MemoryImage(kTransparentImage),
                              );
                            },
                            placeholderErrorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Image(
                                image: MemoryImage(kTransparentImage),
                              );
                            },
                            height: 50,
                            width: MediaQuery.sizeOf(context).width / 4,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          widget.listOfVideos.videos[index].title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.listOfVideos.videos[index].description,
                                overflow: TextOverflow.visible,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: currentBrightness == Brightness.dark
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                        dense: true,
                        onTap: () async {
                          await _showInterstitialAd();
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LandscapePlayer(
                                    url: widget
                                        .listOfVideos.videos[index].videourl,
                                    title: widget
                                        .listOfVideos.videos[index].title);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<String> getFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('response_data');
    print(storedData);
    return storedData ?? "";
  }

  Future<void> shareApp() async {
    // Set the app link and the message to be shared
    const String appLink =
        'https://play.google.com/store/apps/details?id=tenaplus.ahaduweb.com';
    const String message = 'Enjoy My Video PLayer App: $appLink';

    // Share the app link and message using the share dialog
    await FlutterShare.share(
      title: 'Share App',
      text: message,
    );
  }

  void _showRatingDialog() {
    final dialog = RatingDialog(
      initialRating: 1.0,
      title: const Text(
        'Video Player',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      image: const Image(
        image: AssetImage("assets/sp.png"),
        width: 150,
        height: 150,
      ),
      submitButtonText: 'Submit',
      commentHint: 'Set your custom comment hint',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        debugPrint('rating: ${response.rating}, comment: ${response.comment}');
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => dialog,
    );
  }

  Future<void> _loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _interstitialAd = null;
              });
              _loadInterstitialAd();
            },
          );
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd == null) {
      await _loadInterstitialAd();
    }

    if (_interstitialAd != null) {
      await _interstitialAd?.show();
    }
  }
}
