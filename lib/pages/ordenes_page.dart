import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
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

  void presionarCardOrden(String idOrd, String dir, String nomApe, String idenAbon, String actName, int index){
    setState(() {
      idOrden = idOrd;
      direccionOrden = dir;
      nombresApellidos = nomApe;
      actividadNombre = idenAbon;
      identificacionAbon = actName;
    });
    //print(idOrden);
    Navigator.pushReplacementNamed(context, '/orden_page');
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
            //colors: [Colors.black26, Colors.white60],
            colors: [Colors.white, Colors.white],
            )
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.2,
            //margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /*
                FutureBuilder(
                    future: FlutterSession().get('token'),
                    builder: (context, snapshot){
                      return Text(snapshot.hasData ? snapshot.data.toString() : 'Cargando');
                    }
                ),
                */
                Container(
                  //width: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    color: Color(0xFFd1d1d1),
                    //borderRadius: BorderRadius.circular(10.0),
                    border: new Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Center(
                    child: Text(
                      "Ordenes disponibles",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363)),
                    ),
                  ),
                  /*child: Center(
                    child: Text(
                      "Ordenes sin Realizar",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),*/
                ),
                /*
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Divider(
                    color: Colors.black,
                    //height: 36,
                  ),
                ),
                */
                /*
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
                */
                Expanded(
                  flex: 8,
                  child: Scrollbar(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: ordenes == null ? 0 : ordenes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Ink (
                          padding: const EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
                          height: 82,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            /*border: new Border(
                            bottom: BorderSide(width: 0.7, color: Color(0xFFadadad)),
                          ),*/
                          ),
                          child: new ListTile(
                            title: Text("${ordenes[index]["fijo"]} - ${ordenes[index]["celular"]}"),
                            isThreeLine: true,
                            subtitle: Text("${ordenes[index]["direccion"]}\n${ordenes[index]["actividad_name"]}"),

                            trailing: Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              child: Container(
                                width: 30,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Color(0xFFed5565),
                                  borderRadius: BorderRadius.circular(3.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(2, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '0/2',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),

                            onTap: (){
                              presionarCardOrden(ordenes[index]["id_orden"], ordenes[index]["direccion"], ordenes[index]["nombres"] + " " + ordenes[index]["apellidos"], ordenes[index]["actividad_name"], ordenes[index]["num_identidad_abonado"], index);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 0,
                        color: Color(0xFF707070),
                      ),
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



