import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:glass/glass.dart';
import 'ex.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScanScreen(),
  ));
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String name = "";
  bool s = true;
  bool isCameraStopped = false;
  String title1 = '';
 void amk() {
  setState(() {
    if ((name.contains('.com') ||
        name.contains('.net') ||
        name.contains('.dev') ||
        name.contains('.uz') ||
        name.contains('.ru')) &&
        !name.startsWith('http') &&
        name.contains('www')) {
      name = 'https://www.' + name;
    } else if ((name.contains('.com') ||
        name.contains('.net') ||
        name.contains('.dev') ||
        name.contains('.uz') ||
        name.contains('.ru')) &&
        !name.startsWith('http') &&
        !name.contains('www')) {
      // Add "https://" to the beginning of the name string
      name = 'https://' + name;
    }
  });
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amk();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {});
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        name = scanData.code!;
        if (name.isNotEmpty) {
          Vibration.vibrate(duration: 100);
          controller.pauseCamera();
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(top: BorderSide(color: Colors.white)),
                ),
                width: double.infinity,
                height: 550,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          name,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: name));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Copied to clipboard')),
                                  );
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                  size: 45,
                                ),
                                tooltip: 'Copy',
                              ),
                              Text(
                                'Copy',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Share.share(name);
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 45,
                                ),
                                tooltip: 'Share',
                              ),
                              Text(
                                'Share',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  launch(name);
                                },
                                icon: Icon(
                                  Icons.launch,
                                  color: Colors.white,
                                  size: 45,
                                ),
                                tooltip: 'Launch',
                              ),
                              Text(
                                'Open',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      });
    });
  }

  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            dividerColor: Colors.transparent,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Text('Scan'),
              Text('Generate'),
            ],
          ),
          title: Text(
            'ScanCraft',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withOpacity(1),
                  Colors.black.withOpacity(0.3)
                ],
              ),
            ),
          ).asGlass(
              frosted: !true,
              clipBorderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30))),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          leading: DrawerButton(
            style: ButtonStyle(
              iconColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          child: Container(
            child: ListView(children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                arrowColor: Colors.green,
                currentAccountPicture: Image.asset('i/qr.png'),
                accountName: Text(
                  'ScanCraft',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                accountEmail: Text('FlutterDeweloper2008'),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Send message to Developer',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.telegram,
                      color: Colors.white,
                    )
                  ],
                ),
                onTap: () => launch('https://t.me/hater08'),
              ),
              SizedBox(
                height: 0,
              ),
            ]),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          ).asGlass(),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 12,
              child: TabBarView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: [
                          QRView(
                            overlay: QrScannerOverlayShape(
                              borderRadius: 20,
                              borderColor: Colors.white,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 300,
                            ),
                            key: qrKey,
                            onQRViewCreated: onQRViewCreated,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 70),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isFlashOn = !isFlashOn;
                                          controller?.toggleFlash();
                                        });
                                      },
                                      icon: Icon(
                                        isFlashOn
                                            ? Icons.flashlight_off
                                            : Icons.flashlight_on,
                                        size: 44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ).asGlass(
                                      clipBorderRadius:
                                          BorderRadius.circular(50)),
                                  SizedBox(
                                    height: 150,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          controller?.resumeCamera();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        size: 44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ).asGlass(
                                      clipBorderRadius:
                                          BorderRadius.circular(50)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                MyWidget()
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final ButtonStyle? style;

  const DrawerButton({Key? key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      style: style,
      child: Icon(Icons.menu),
    );
  }
}
