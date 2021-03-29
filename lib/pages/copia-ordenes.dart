/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/orden_page.dart';

String idOrden = '';
String direccionOrden = '';
String nombresApellidos = '';
String identificacionAbon = '';
String actividadNombre = '';

class OrdenesPage extends StatefulWidget {
  OrdenesPage({this.codigoTecnico});
  final int codigoTecnico;
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPage> {
  //Map data;
  List ordenes;

  getOrdenes() async{
    String id = codigoTecnico.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getOrdenes.php/?codigoTecnico="+id;
    //http.Response response = await http.get('http://ns212.cablebox.co:5510/appmovil/getOrdenes.php');
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);
    setState(() {
      ordenes = data['ordenes'];

    });
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
          //height: MediaQuery.of(context).size.height/1.1,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.white60],
              )
          ),
          child: Flexible(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 30,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Center(
                    child: Text(
                      "Ordenes sin Realizar",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  ),
                ),

                Container(
                  //height: MediaQuery.of(context).size.height / 1.6,
                  child: Flexible(
                    child: ListView.builder(

                      //padding: const EdgeInsets.only(left: 8),
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
                                padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20
                                          ),
                                          child: Text("Telefono: ${ordenes[index]["fijo"]} - ${ordenes[index]["celular"]}"),
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20
                                          ),
                                          child: Text("Direccion: ${ordenes[index]["direccion"]}"),
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20
                                          ),
                                          child: Text("Tipo de orden: ${ordenes[index]["actividad_name"]}"),
                                        )
                                    ),
                                  ],
                                ),
                              )

                          ),
                          onTap: (){
                            setState(() {
                              idOrden = ordenes[index]["id_orden"];
                              direccionOrden = ordenes[index]["direccion"];
                              nombresApellidos = ordenes[index]["nombres"] + " " + ordenes[index]["apellidos"];
                              actividadNombre = ordenes[index]["actividad_name"];
                              identificacionAbon = ordenes[index]["num_identidad_abonado"];
                            });
                            //print("${ordenes[index]["id_orden"]}");
                            Navigator.pushReplacementNamed(context, '/orden_page');

                          },
                        );
                      },
                    ),
                  ),
                ),



              ],
            ),

          ),
        )

    );
  }
}

*/

