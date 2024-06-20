import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  bool scanCompleted = false;

  String results = "";

  void onCloseScreen() {
    scanCompleted = false;
  }

  // QR Detected
  void qrDetected(BuildContext context, String result) {
    setState(() {
      results = result;
    });
    if(results.isUrl()) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("URL Detected...", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
              [
              Text("Do you want to open url : $results"),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(onPressed: () async{
                      try {
                        Uri url = Uri.parse(results);
                        await launchUrl(url);
                      } catch(e) {
                        print('Url error $e');
                      }

                    }, icon: const Icon(Icons.open_in_browser,), label: const Text("Open",)),

                    ElevatedButton.icon(onPressed: () {
                      Navigator.of(context).pop();
                    }, icon: const Icon(Icons.close,), label: const Text("Close",)),
                  ],
                ),

              ]
        )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 10;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("QR Code Scanner", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
                width: screenWidth,
                height: screenWidth,
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children:
                    [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: MobileScanner(onDetect: (capture){
                          if(!scanCompleted) {
                            final code =  capture.raw ?? "---";
                            String result = code[0]['rawValue'];
                            scanCompleted = true;
                            qrDetected(context, result);
                          }
                        },

                      ),
                    ),

                      QRScannerOverlay(overlayColor: Colors.black38,)

                  ]
                  ),
            )),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text("Decoded Results :\n$results", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)),

                      IconButton(onPressed: () {}, icon: const Icon(Icons.copy))
                    ],
                  ),


                  Visibility(
                      visible: scanCompleted,
                      child: ElevatedButton(child: const Text("Scan Again"), onPressed: () {
                        setState(() {
                          scanCompleted = false;
                        });
                      },
                      )
                  )



                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
