import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/main.dart';

String idOrdenR = '';
String direccionOrdenR = '';
String nombresApellidosR = '';
String identificacionAbonR = '';
String actividadNombreR = '';
String telefonoOrdenCompleta = '';

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
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getOrdenesRealizadas.php?codigoTecnico="+id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    setState(() {
      ordenes = data['ordenes'];
    });
    print(ordenes);
  }

  void presionarCardOrdenR(String idOrd, String dir, String nomApe, String idenAbon, String actName, String thistelefono){
    setState(() {
      idOrdenR = idOrd;
      direccionOrdenR = dir;
      nombresApellidosR = nomApe;
      actividadNombreR = idenAbon;
      identificacionAbonR = actName;
      telefonoOrdenCompleta = thistelefono;
    });
    Navigator.pushReplacementNamed(context, '/ordenRealizada_page');
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
                    color: Color(0xFFd6d6d6),
                    border: new Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Center(
                    child: AutoSizeText(
                      "Ordenes realizadas",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'RobotoMono'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
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

                                trailing: Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  /*child: Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF378f4d),
                                    size: 25.0,
                                  ),*/
                                  child: Icon(
                                    ordenes[index]["orden_estado"] == 'realizada' ? Icons.check_circle : Icons.warning,
                                    color: ordenes[index]["orden_estado"] == 'realizada' ? Color(0xFF378f4d) : Color(0xFFf8a326),
                                    size: 25.0,
                                  ),
                                ),

                                onTap: (){
                                  presionarCardOrdenR(ordenes[index]["id_orden"], ordenes[index]["direccion"], ordenes[index]["nombres"] + " " + ordenes[index]["apellidos"], ordenes[index]["actividad_name"], ordenes[index]["num_identidad_abonado"], ordenes[index]["celular"]);
                                },
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
                )

              ],
            ),

          ),

        )

    );
  }
}



