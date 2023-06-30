import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mobibyte/screens/loading_screen.dart';
import 'package:mobibyte/screens/mining_screen.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../screens/profile_screen.dart';
import '../provider/mine.dart';
import '../screens/pp_screen.dart';
import '../screens/refer_screen.dart';
import '../provider/app_settings.dart';

class Home extends StatefulWidget {
  AsyncSnapshot<Map<String, dynamic>> snapshot;
  Home(this.snapshot);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String displayName = "";
  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  int page = 0;
  void setPageValue(int val) {
    setState(() {
      page = val;
      print("page:$page");
    });
  }

  @override
  final _advancedDrawerController = AdvancedDrawerController();
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    final snapShot = widget.snapshot;
    final mineData = Provider.of<Mine>(context);
    page = mineData.page;
    final appSettings = Provider.of<AppSettings>(context);
    String photoUrl =
        "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg";
    if (snapShot.data != null) {
      photoUrl = snapShot.data!['imageUrl'];
    }
    displayName = snapShot.data!['name'];
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.home),
                title: const Text('Home'),
              ),
              ListTile(
                onTap: () {
                  mineData.setPageNo(2);
                  mineData.refreshCoins();
                  _advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.account_circle_rounded),
                title: const Text('Profile'),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.favorite),
                title: const Text('Favourites'),
              ),
              ListTile(
                onTap: () async {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (ctx) => LoadingScreen()));
                  showDialog(
                    context: context,
                    builder: (ctx) => const AlertDialog(
                      actions: [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  );
                  _auth.signOut();

                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Log Out'),
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _advancedDrawerController.showDrawer();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text("Welcome $displayName !"),
          actions: [
            Container(
              padding: const EdgeInsets.all(7),
              child: PopupMenuButton(
                enableFeedback: true,
                padding: const EdgeInsets.all(8.0),
                elevation: 10,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                ),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    onTap: () {
                      mineData.refreshCoins();
                      setState(() {
                        mineData.setPageNo(2);
                      });
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      title: Text(
                        displayName,
                      ),
                      subtitle: FittedBox(
                        child: Text(
                          _auth.currentUser!.email.toString(),
                        ),
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    height: 2,
                    child: PopupMenuDivider(
                      height: 10,
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      mineData.refreshCoins();
                      setState(() {
                        mineData.setPageNo(2);
                      });
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.account_box),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: const [
                        Icon(Icons.settings),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    height: 2,
                    child: PopupMenuDivider(
                      height: 10,
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      _auth.signOut();
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Log out'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: (page == 0)
            ? MiningScreen()
            : (page == 1)
                ? ReferScreen()
                : (page == 2)
                    ? ProfileScreen(mineData.setPageNo)
                    : Container(),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          onTap: (val) {
            mineData.refreshCoins();
            mineData.setPageNo(val);
            setState(() {});

            // final CurvedNavigationBarState? navBarState =
            //     _bottomNavigationKey.currentState;
            // navBarState?.setPage(val);
          },
          backgroundColor: Theme.of(context).backgroundColor,
          height: 55,
          index: mineData.page,
          color: Theme.of(context).primaryColor,
          items: const [
            Icon(Icons.multiline_chart_sharp, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.portrait_rounded, size: 30),
          ],
        ),
      ),
    );
  }
}
