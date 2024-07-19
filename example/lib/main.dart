import 'package:cached_firestorage/lib.dart';
import 'package:cached_firestorage_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CachedFirestorage.instance.cacheTimeout = 30;
  CachedFirestorage.instance.setStorageKeys({'pp': 'pp'});

  runApp(const Demo());
}

class Demo extends StatelessWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Firestorage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentPic = '2-1.jpeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Firestorage DEMO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ListView(
            children: [
              const Text(
                'The standard way is using a FutureBuilder.\n'
                'All you have to do is providing the Firebase Storage path and a key of your choice.\n'
                'CachedFirestorage will fetch the download url the first time, '
                'and keep that in cache until the timer expires',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: CachedFirestorage.instance.getDownloadURL(
                  mapKey: '1',
                  filePath: '1.jpeg',
                ),
                builder: (_, snapshot) => snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator.adaptive()
                    : snapshot.hasError
                        ? const Text('An error occurred')
                        : Image.network(
                            snapshot.data!,
                            height: 100,
                          ),
              ),
              const Divider(height: 50),
              const Text(
                'You can invalidate the cache for a specific key every time you want\n'
                'This could be useful if you need to update the url associated a specific key.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: CachedFirestorage.instance.getDownloadURL(
                  mapKey: '2',
                  filePath: currentPic,
                ),
                builder: (_, snapshot) => snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator.adaptive()
                    : snapshot.hasError
                        ? const Text('An error occurred')
                        : Image.network(
                            snapshot.data!,
                            height: 100,
                          ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'Change URL',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      setState(() {
                        currentPic = currentPic == '2-1.jpeg' ? '2-2.jpeg' : '2-1.jpeg';
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Text(
                      'Remove cache + Change URL',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      setState(() {
                        currentPic = currentPic == '2-1.jpeg' ? '2-2.jpeg' : '2-1.jpeg';
                        CachedFirestorage.instance.removeCacheEntry(mapKey: '2');
                      });
                    },
                  ),
                ],
              ),
              const Divider(height: 50),
              const Text(
                'CachedFirestorage ships with a utility widget named RemotePicture,\n'
                'which is already optimized for fetching and displaying images stored'
                'in Firebase Storage',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: RemotePicture(
                      imagePath: '3.jpeg',
                      mapKey: '3',
                    ),
                  ),
                ],
              ),
              const Divider(height: 50),
              const Text(
                'You can also use it for an avatar',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RemotePicture(
                    imagePath: 'avatar.jpeg',
                    mapKey: 'avatar',
                    useAvatarView: true,
                    avatarViewRadius: 60,
                    fit: BoxFit.cover,
                    storageKey: 'pp',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
