// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:goodcare/ksr_resep_list.dart';
// import 'package:goodcare/my_api.dart';
// import 'package:goodcare/my_class.dart';
// import 'package:http/http.dart' as http;

// class DokRekamView extends StatefulWidget {
//   final String xtkn, xidrm, xnoreg, xnorm, xtgl, xnmpas, xkeluhan, xdiag, xtindakan, xbytdkn;
//   const DokRekamView({ Key? key, required this.xtkn, required this.xidrm, required this.xnoreg, required this.xnorm, required this.xtgl, required this.xnmpas, required this.xkeluhan, required this.xdiag, required this.xtindakan, required this.xbytdkn }) : super(key: key);

//   @override
//   _DokRekamViewState createState() => _DokRekamViewState();
// }

// class ModelResep{
//   final String idresep, noresep, nmobat, dosis, jml, cttn, hrg, cek;
//   ModelResep(this.idresep, this.noresep, this.nmobat, this.dosis, this.jml, this.cttn, this.hrg, this.cek);
// }

// class _DokRekamViewState extends State<DokRekamView> {
//   bool loading = false;
//   List <ModelResep> listResep = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   void dialogEnd(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context){
//         return AlertDialog(
//           title: Text('Anda yakin ?'),
//           actions: <Widget> [
//             TextButton(
//               child: Text("Tidak"),
//               onPressed: (){
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Iya"),
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       }
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade900,
//         title: Text('Transaksi Rawat Jalan'),
//         elevation: 0,
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('No. Registrasi: ', style: TextStyle(fontSize: 18.0)),
//                         Text(widget.xnoreg, style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('No. Rekam Medis: ', style: TextStyle(fontSize: 18.0)),
//                         Text(widget.xnorm, style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Nama Pasien: ', style: TextStyle(fontSize: 18.0)),
//                         Text(widget.xnmpas, style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Keluhan', style: TextStyle(fontSize: 18.0)),
//                         Text(widget.xkeluhan, style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Diagnosa', style: TextStyle(fontSize: 18.0)),
//                         Text(widget.xdiag, style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Tindakan', style: TextStyle(fontSize: 18.0)),
//                         Text(widget.xtindakan, style: TextStyle(fontSize: 16.0)),
//                       ],
//                     ),
//                   ),
                  
//                 ],
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: InkWell(
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Icon(Icons.save, color: Colors.white),
//                     // SizedBox(width: 10.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: Text('Resep Obat', style: TextStyle(color: Colors.purple.shade900)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 20.0),
//                       child: Text('Lihat Resep', style: TextStyle(color: Colors.purple.shade900)),
//                     ),
//                   ],
//                 ),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                   color: Colors.white,
//                   border: Border.all(color: Colors.purple),
//                 ),
//               ),
//               onTap: (){
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => KsrResepList(xtkn: widget.xtkn, xidrm: widget.xidrm)
//                 ));
//               },
//             ),
//           ),

          
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: InkWell(
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.save, color: Colors.white),
//                     SizedBox(width: 10.0),
//                     Text('Selesai', style: TextStyle(color: Colors.white)),
//                   ],
//                 )),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   color: Colors.purple.shade900,
//                 ),
//               ),
//               onTap: (){
//                 dialogEnd(context);
//               },
//             ),
//           ),

//         ],
//       ),
//     );
//   }

// }