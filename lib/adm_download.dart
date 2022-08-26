import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_rekap_jp.dart';
import 'package:goodcare/adm_rekap_wilayah.dart';
import 'package:goodcare/my_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AdmDownload extends StatefulWidget {
  // final String xtkn;
  const AdmDownload({ Key? key,}) : super(key: key);

  @override
  _AdmDownloadState createState() => _AdmDownloadState();
}

class _AdmDownloadState extends State<AdmDownload> {
  String xidus='', xnmus='', xrole='', xtkn='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final SharedPreferences pref = await _prefs;
    setState(() {
      xidus = pref.getString("xidus") ?? '';
      xnmus = pref.getString("xnmus") ?? '';
      xrole = pref.getString("xrole") ?? '';
      xtkn = pref.getString("xtkn") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('tabHistory', style: TextStyle(color: Colors.white),).tr(),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          _widgetBgUp(mediaQuery),
          _widgetList()
        ],
      )
    );
  }

  Widget _widgetBgUp(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), //(left, top, right, bottom)
      child: Container(
        width: mediaQuery.size.width,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          borderRadius: BorderRadius.only(
            // bottomLeft: Radius.circular(35.0),
            bottomRight: Radius.circular(30.0),
          ),
          // border: Border.all(color: Colors.purple),
          color: Colors.purple.shade900,
        ),
      ),
    );
  }

  Widget _widgetList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 50, 12, 0), //(left, top, right, bottom)
      child: Container(
        height: 700.0,
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.purple),
        ),
        child: ListView(
          children: [
            Text("unduh".tr(), style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Text('dataPas', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.download, size: 40, color: Colors.purple.shade900,),
                    onTap: () async {
                      Uri uri = Uri.parse(MyApi.apiPDFPas);
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: Border.all(color: Colors.purple.shade900),
              ),
            ),
            SizedBox(height: 20,),
            Container(  
              padding: const EdgeInsets.all(8.0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Text('dataRJ', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.download, size: 40, color: Colors.purple.shade900,),
                    onTap: () async {
                      Uri uri = Uri.parse(MyApi.apiPDFRM);
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: Border.all(color: Colors.purple.shade900),
              ),
            ),
            SizedBox(height: 20,),
            Container(  
              padding: const EdgeInsets.all(8.0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Text('dataObat', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.download, size: 40, color: Colors.purple.shade900,),
                    onTap: () async {
                      Uri uri = Uri.parse(MyApi.apiPDFObat);
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: Border.all(color: Colors.purple.shade900),
              ),
            ),
            
            SizedBox(height: 20,),
            Text("rekap".tr(), style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Container(  
              padding: const EdgeInsets.all(8.0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Text('perkecamatan', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.purple.shade900,),
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdmRekapWilayah(xtkn: xtkn)
                      ));
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: Border.all(color: Colors.purple.shade900),
              ),
            ),
            SizedBox(height: 20,),
            Container(  
              padding: const EdgeInsets.all(8.0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Text('perjp', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.purple.shade900,),
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdmRekapJP(xtkn: xtkn)
                      ));
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: Border.all(color: Colors.purple.shade900),
              ),
            ),

          ],
        ),
      ),
    );
  }


}