import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_key_detector/media_key_detector.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _platformName;
  Map<MediaKey, bool> keyPressed = {
    MediaKey.playPause: false,
    MediaKey.rewind: false,
    MediaKey.fastForward: false,
  };

  void _mediaKeyListener(MediaKey mediaKey) {
    debugPrint('$mediaKey pressed');
    if (keyPressed[mediaKey] == false) {
      setState(() => keyPressed[mediaKey] = true);
      Timer(const Duration(seconds: 3), () {
        setState(() => keyPressed[mediaKey] = false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mediaKeyDetector.addListener(_mediaKeyListener);
  }

  @override
  void dispose() {
    mediaKeyDetector.removeListener(_mediaKeyListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('MediaKeyDetector Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Press a Media key on your keyboard to highlight the corresponding icon:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fast_rewind_rounded,
                  size: 40,
                  color: (keyPressed[MediaKey.rewind] ?? false)
                      ? colors.primary
                      : colors.onBackground,
                ),
                Icon(
                  Icons.play_circle_rounded,
                  size: 40,
                  color: (keyPressed[MediaKey.playPause] ?? false)
                      ? colors.primary
                      : colors.onBackground,
                ),
                Icon(
                  Icons.fast_forward_rounded,
                  size: 40,
                  color: (keyPressed[MediaKey.fastForward] ?? false)
                      ? colors.primary
                      : colors.onBackground,
                ),
              ],
            ),
            if (_platformName == null)
              const SizedBox.shrink()
            else
              Text(
                'Platform Name: $_platformName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (!context.mounted) return;
                try {
                  final result = await getPlatformName();
                  setState(() => _platformName = result);
                } catch (error) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Get Platform Name'),
            ),
          ],
        ),
      ),
    );
  }
}
