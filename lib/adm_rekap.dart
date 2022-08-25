// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:goodcare/adm_rekap_jp.dart';
// import 'package:goodcare/adm_rekap_wilayah.dart';

// class AdmRekap extends StatefulWidget {
//   final String xtkn;
//   const AdmRekap({ Key? key, required this.xtkn }) : super(key: key);

//   @override
//   _AdmRekapState createState() => _AdmRekapState();
// }

// class ModelRekap{
//   final String kec, jml;
//   ModelRekap(this.kec, this.jml);
// }

// class _AdmRekapState extends State<AdmRekap> {
//   bool loading = false;
//   List <ModelRekap> list = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade900,
//         title: Text('rekap').tr(),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Column(
//           children: [
//             InkWell(
//               child: Container(
//                 margin: EdgeInsets.only(top: 8, bottom: 8),
//                 child: ListTile(
//                   leading: Icon(Icons.map, color: Colors.purple.shade900,),
//                   title: Text('perkecamatan', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
//                   trailing: Icon(Icons.arrow_forward, color: Colors.purple.shade900,),
//                 ),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                   color: Colors.white,
//                   border: Border.all(color: Colors.purple.shade900),
//                 ),
//               ),
//               onTap: (){
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => AdmRekapWilayah(xtkn: widget.xtkn)
//                 ));
//               },
//             ),
//             InkWell(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: ListTile(
//                   leading: Icon(Icons.view_kanban_rounded, color: Colors.purple.shade900,),
//                   title: Text('perjp', style: TextStyle(color: Colors.purple.shade900, fontSize: 18, fontWeight: FontWeight.bold),).tr(),
//                   trailing: Icon(Icons.arrow_forward, color: Colors.purple.shade900,),
//                 ),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                   color: Colors.white,
//                   border: Border.all(color: Colors.purple.shade900),
//                 ),
//               ),
//               onTap: (){
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => AdmRekapJP(xtkn: widget.xtkn)
//                 ));
//               },
//             ),
            

//           ],
//         )
//       ),
      
//     );
//   }
// }