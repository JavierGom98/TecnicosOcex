import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';
import 'dart:async';
import 'package:tecnicos_cm/pages/tab_page.dart';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/orden_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:cool_alert/src/constants/images.dart';

import 'cosultas_bd.dart';

String idOrden = '';
String direccionOrden = '';
String nombresApellidos = '';
String identificacionAbon = '';
String actividadNombre = '';
String telefono = '';
String telefonoFijo = '';
double duracionActividad = 0;
String tipoActividad = '';
String ordenBD = '';
int numOrden = 0;

List ordenes;

class OrdenesPage extends StatefulWidget {
  OrdenesPage({this.codigoTecnico});
  final int codigoTecnico;
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPage> {
  //Map data;
  String animEstado = AppAnim.loading;

  getOrdenes() async{
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getOrdenes.php?codigoTecnico="+id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    setState(() {
      ordenes = data['ordenes'];
      numOrdenes = ordenes.length;
      if(numOrdenes > 0)
        notiOrdenes = true;
      else
        notiOrdenes = false;
      print("num ordenes "+numOrdenes.toString());
    });

    print(ordenes);
  }

  void presionarCardOrden(String idOrd, String dir, String nomApe, String idenAbon, String actName, String thistelefono, String thisfijo, int index, double duracion, String tipoA, String ordBD){
    setState(() {
      idOrden = idOrd;
      direccionOrden = dir;
      nombresApellidos = nomApe;
      actividadNombre = idenAbon;
      identificacionAbon = actName;
      telefono = thistelefono;
      telefonoFijo = thisfijo;
      duracionActividad = duracion;
      tipoActividad = tipoA;
      ordenBD = ordBD;
    });
    Navigator.pushReplacementNamed(context, '/orden_page');
  }

  @override
  void initState() {
    super.initState();
    getOrdenes();
    //getOrdenesBD();
    
    funcionesSocket();
  }

  //Socket
  void funcionesSocket() {
    client.on('actualizar_ordenes', (data) {
      print('actualizar_ordenes');
      getOrdenes();
    });
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
                colors: [Colors.white, Colors.white],
              )
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    color: Color(0xFFd6d6d6),
                    border: new Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Center(
                    /*child: Text(
                      "Ordenes disponibles",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'RobotoMono'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),*/
                    child: AutoSizeText(
                      "Ordenes disponibles",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'RobotoMono'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 0, bottom: 0),
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
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: new ListTile(
                                title: AutoSizeText(
                                  "${ordenes[index]["fijo"]} - ${ordenes[index]["celular"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ), //Text("${ordenes[index]["fijo"]} - ${ordenes[index]["celular"]}"),
                                isThreeLine: true,
                                subtitle: AutoSizeText(
                                  "${ordenes[index]["direccion"]}\n${ordenes[index]["actividad_name"]}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),//Text("${ordenes[index]["direccion"]}\n${ordenes[index]["actividad_name"]}"),

                                onTap: (){
                                  presionarCardOrden(ordenes[index]["id_orden"], ordenes[index]["direccion"], ordenes[index]["nombres"] + " " + ordenes[index]["apellidos"], ordenes[index]["actividad_name"], ordenes[index]["num_identidad_abonado"], ordenes[index]["celular"], ordenes[index]["fijo"], index, double.parse(ordenes[index]["actividad_duracion"]), ordenes[index]["actividad_plan"], ordenes[index]["ordenBD"]);
                                },

                                
                                trailing: ordenes[index]["iniciado"] ? Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 30,
                                    height: 25,
                                    /*decoration: BoxDecoration(
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
                                    ),*/
                                    alignment: Alignment.center,
                                    child: FlareActor(
                                      animEstado,
                                      animation: "play",
                                    )
                                  ),
                                ) : null,
                                /*trailing: Container(
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
                                ),*/
                              ),
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
                ),
              ],
            ),

          ),

        )

    );
  }
}



