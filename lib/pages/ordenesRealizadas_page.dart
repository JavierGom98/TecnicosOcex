import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/main.dart';

String idOrden = '';
String direccionOrden = '';
String nombresApellidos = '';
String identificacionAbon = '';
String actividadNombre = '';

class OrdenesRealizadasPage extends StatefulWidget {
  OrdenesRealizadasPage({this.codigoTecnico});
  final int codigoTecnico;
  @override
  _OrdenesRealizadasPageState createState() => _OrdenesRealizadasPageState();
}

class _OrdenesRealizadasPageState extends State<OrdenesRealizadasPage> {
  //Map data;
  List ordenes;

  getOrdenes() async{
    String id = codigoTecnico.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getOrdenes.php/?codigoTecnico="+id;
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);
    setState(() {
      ordenes = data['ordenes'];

    });
  }

  void presionarCardOrden(String idOrd, String dir, String nomApe, String idenAbon, String actName){
    setState(() {
      idOrden = idOrd;
      direccionOrden = dir;
      nombresApellidos = nomApe;
      actividadNombre = idenAbon;
      identificacionAbon = actName;
    });
    //Navigator.pushReplacementNamed(context, '/orden_page');
  }

  @override
  void initState() {
    super.initState();
    getOrdenes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.white60],
              )
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.2,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                FutureBuilder(
                    future: FlutterSession().get('token'),
                    builder: (context, snapshot){
                      return Text(snapshot.hasData ? snapshot.data.toString() : 'Cargando');
                    }
                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "Ordenes Realizadas",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Divider(
                    color: Colors.black,
                    //height: 36,
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ordenes == null ? 0 : ordenes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Telefono: ${ordenes[index]["fijo"]} - ${ordenes[index]["celular"]}"),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Direccion: ${ordenes[index]["direccion"]}"),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Tipo de orden: ${ordenes[index]["actividad_name"]}"),
                                  ),
                                ],
                              ),
                            )
                        ),
                        onTap: (){
                          presionarCardOrden(ordenes[index]["id_orden"], ordenes[index]["direccion"], ordenes[index]["nombres"] + " " + ordenes[index]["apellidos"], ordenes[index]["actividad_name"], ordenes[index]["num_identidad_abonado"]);
                        },
                      );
                    },
                  ),
                )
              ],
            ),

          ),

        )

    );
  }
}



