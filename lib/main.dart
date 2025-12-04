import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(BassTrainerApp());
}

class BassTrainerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bass Scales Trainer',
      theme: ThemeData.dark(),
      home: BassTrainerHome(),
    );
  }
}

class BassTrainerHome extends StatefulWidget {
  @override
  _BassTrainerHomeState createState() => _BassTrainerHomeState();
}

class _BassTrainerHomeState extends State<BassTrainerHome> {
  final Map<String, List<String>> scales = {
    "Major": ["Root", "Whole", "Whole", "Half", "Whole", "Whole", "Whole", "Half"],
    "Minor": ["Root", "Whole", "Half", "Whole", "Whole", "Half", "Whole", "Whole"],
    "Pentatonic Major": ["Root", "Whole", "Whole", "Minor 3rd", "Whole", "Minor 3rd"],
    "Pentatonic Minor": ["Root", "Minor 3rd", "Whole", "Whole", "Minor 3rd", "Whole"],
  };

  final Map<String, List<String>> fretboard = {
    "E":  ["E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E"],
    "A":  ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A"],
    "D":  ["D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D"],
    "G":  ["G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G"],
  };

  String selectedScale = "Major";
  String selectedRoot = "E";
  String selectedString = "E";

  List<String> get stringOptions => fretboard.keys.toList();
  List<String> get rootOptions => fretboard["E"]!.toSet().toList()..sort((a, b) => a.compareTo(b));
  List<String> get scaleOptions => scales.keys.toList();

  final List<String> tips = [
    "Keep your thumb anchored for stability.",
    "Use alternate finger plucking.",
    "Start slow, then build speed.",
    "Listen to great bass players for inspiration.",
    "Practice with a metronome.",
    "Try muting unused strings."
  ];

  String get randomTip => tips[Random().nextInt(tips.length)];

  void showScaleInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Scale Info"),
        content: Text("You selected the $selectedRoot $selectedScale scale."),
      ),
    );
  }

  void showFretboard(BuildContext context) {
    final notes = fretboard[selectedString] ?? [];
    final display = List.generate(13, (i) => "Fret $i: ${notes[i % 12]}").join("\n");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${selectedString} String Notes"),
        content: Text(display),
      ),
    );
  }

  void showDailyChallenge(BuildContext context) {
    final rand = Random();
    setState(() {
      selectedScale = scaleOptions[rand.nextInt(scaleOptions.length)];
      selectedRoot = rootOptions[rand.nextInt(rootOptions.length)];
      selectedString = stringOptions[rand.nextInt(stringOptions.length)];
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Challenge"),
        content: Text("Try the $selectedRoot $selectedScale scale on $selectedString string!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Bass Scales Trainer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("🎸 Tip: $randomTip", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedScale,
              onChanged: (val) => setState(() => selectedScale = val!),
              items: scaleOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              dropdownColor: Colors.grey[900],
            ),
            DropdownButton<String>(
              value: selectedRoot,
              onChanged: (val) => setState(() => selectedRoot = val!),
              items: rootOptions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              dropdownColor: Colors.grey[900],
            ),
            DropdownButton<String>(
              value: selectedString,
              onChanged: (val) => setState(() => selectedString = val!),
              items: stringOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              dropdownColor: Colors.grey[900],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => showScaleInfo(context),
              child: Text("Show Scale Info"),
            ),
            ElevatedButton(
              onPressed: () => showFretboard(context),
              child: Text("Show Selected String Notes"),
            ),
            ElevatedButton(
              onPressed: () => showDailyChallenge(context),
              child: Text("Random Challenge"),
            ),
            Spacer(),
            Center(
              child: Text("Learn with your ears, play with your soul.", style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}
