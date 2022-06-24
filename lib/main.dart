import 'dart:async';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' ;

void main() => runApp(SpeechSampleApp());

class SpeechSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Flutter',
      debugShowCheckedModeBanner:false,
      theme:ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget{
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>{
final Map<String, HighlightedWord> _highlights = {
  'flutter': HighlightedWord(
    onTap: () => print('flutter'),
    textStyle: const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    ),
  ),
  'voice': HighlightedWord(
    onTap: () => print('voice'),
    textStyle: const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
  ),
  'subscribe': HighlightedWord(
    onTap: () => print('subscribe'),
    textStyle: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
  ),
  'like': HighlightedWord(
    onTap: () => print('like'),
    textStyle: const TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.bold,
    ),
  ),
  'comment': HighlightedWord(
    onTap: () => print('comment'),
    textStyle: const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
  ),
};
  SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = SpeechToText();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('COnfidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 12000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
        child:Icon(_isListening ? Icons.mic : Icons.mic_none)
    ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
void _listen() async {
  if (!_isListening) {
    bool available = await _speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }
        }),
      );
    }
  } else {
    setState(() => _isListening = false);
    _speechToText.stop();
  }
}
}