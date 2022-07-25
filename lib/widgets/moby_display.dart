import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_settings.dart';
import '../provider/mine.dart';
import '../screens/loading_screen.dart';

class MobyDisplay extends StatefulWidget {
  @override
  _MobyDisplayState createState() => _MobyDisplayState();
}

class _MobyDisplayState extends State<MobyDisplay> {
  @override
  Widget build(BuildContext context) {
    final mineData = Provider.of<Mine>(context);
    return FutureBuilder(
      future: Provider.of<AppSettings>(context).getUserdataMap,
      builder: (ctx, AsyncSnapshot<Map<String, dynamic>> sc) {
        if (sc.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('MobiBytes (MOBY) balance:'),
                IconButton(
                  onPressed: () {
                    mineData.refreshCoins();
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            CircleAvatar(
              radius: MediaQuery.of(context).size.width / 15,
              backgroundColor: Theme.of(context).cardColor,
              child: FittedBox(
                child: Text(
                  sc.data!['MOBY'].toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
