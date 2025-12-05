import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const BassTrainerApp());
}

class BassTrainerApp extends StatelessWidget {
  const BassTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bass Scales Trainer",
      theme: ThemeData.dark(),
      home: const BassTrainerHome(),
    );
  }
}

class BassTrainerHome extends StatefulWidget {
  const BassTrainerHome({super.key});

  @override
  BassTrainerHomeState createState() => BassTrainerHomeState();
}

class BassTrainerHomeState extends State<BassTrainerHome> {
  final AudioPlayer _player = AudioPlayer();

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
  String selectedRoot = "E1";
  String selectedString = "E";
  int selectedFret = 0;

  List<String> get stringOptions => fretboard.keys.toList();
  List<String> get rootOptions => [
        "E1", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E2"
      ];
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

  void playNote(String filename) async {
    final path = "sounds/$filename";
    print("Trying to play: assets/$path");
    try {
      await _player.play(AssetSource(path));
    } catch (e) {
      print("Error playing $path: $e");
    }
  }

  void showScaleInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Scale Info"),
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
        title: Text("$selectedString String Notes"),
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
      selectedFret = rand.nextInt(13);
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Challenge"),
        content: Text("Try the $selectedRoot $selectedScale scale on $selectedString string!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Bass Scales Trainer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("🎸 Tip: $randomTip", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
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
            DropdownButton<int>(
              value: selectedFret,
              onChanged: (val) => setState(() => selectedFret = val!),
              items: List.generate(13, (i) => DropdownMenuItem(value: i, child: Text("Fret $i"))),
              dropdownColor: Colors.grey[900],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => showScaleInfo(context),
              child: const Text("Show Scale Info"),
            ),
            ElevatedButton(
              onPressed: () => showFretboard(context),
              child: const Text("Show Selected String Notes"),
            ),
            ElevatedButton(
              onPressed: () => showDailyChallenge(context),
              child: const Text("Random Challenge"),
            ),
            ElevatedButton(
              onPressed: () => playNote("${selectedString.toLowerCase()}$selectedFret.mp3"),
              child: const Text("Play Selected Note"),
            ),
            const Spacer(),
            const Center(
              child: Text("Learn with your ears, play with your soul.", style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}
