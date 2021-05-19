import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/main.dart';

List materialesOrdenes;

class MaterialesPage extends StatefulWidget {
  MaterialesPage({this.codigoTecnico});
  final int codigoTecnico;
  @override
  _MaterialesPageState createState() => _MaterialesPageState();
}

class _MaterialesPageState extends State<MaterialesPage> {
  Map data;
  List materiales;
  bool falta_material = false;
  int solicitoMaterial = 0;
  bool visibleSolicitar = false;
  final scaffoldMain = new GlobalKey<ScaffoldState>();

  getMateriales() async{
    falta_material = false;
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getMateriales.php?codigoTecnico="+id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);

    enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?funcion=getTecnico&codigoTecnico="+id;
    print(enlace);
    response = await http.get(Uri.parse(enlace));
    var tecnico_data = json.decode(response.body);

    for(int i = 0; i < data['materiales'].length; i++){
      if(!data['materiales'][i]["estado"])
        falta_material = true;
    }
    setState(() {
      materiales = data['materiales'];
      solicitoMaterial = int.parse(tecnico_data['tecnico'][0]['solicitoMaterial']);
      if(falta_material && solicitoMaterial == 0)
        visibleSolicitar = true;
      else
        visibleSolicitar = false;
    });
  }

  @override
  void initState() {
    getMateriales();
    setState(() {
      materialesOrdenes = materiales;
    });
    funcionesSocket();
  }
  
  //Socket
  void funcionesSocket() {
    client.on('actualizar_materiales', (data) {
      print('actualizar_materiales');
      getMateriales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMain,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
              //colors: [Colors.black26, Colors.white60],
            )
        ),

        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.2,
          margin: EdgeInsets.all(0),
          //margin: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
          /*decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            //border: Border.all(color: Colors.blueAccent)
          ),*/
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                /*Container(
                  //margin: EdgeInsets.only(top: 10),
                  //height: 30,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Center(
                    child: Text(
                      "Materiales Disponibles",
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
                ),*/

                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFd6d6d6),
                    //borderRadius: BorderRadius.circular(0.0),
                    border: new Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Center(
                    child: AutoSizeText(
                      "Materiales Disponibles",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'RobotoMono'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                /*
                Expanded(
                  flex: 5,

                  child: Scrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 8),
                      shrinkWrap: true,
                      itemCount: materiales == null ? 0 : materiales.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text("${materiales[index]["nombre"]}: ${materiales[index]["cantidad"]}"),
                        );
                      },

                    ),
                  ),

                ),
                  */

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Scrollbar(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: materiales == null ? 0 : materiales.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Ink (
                            padding: const EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: new ListTile(
                              title: AutoSizeText(
                                "${materiales[index]["nombre"]}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),//Text("${materiales[index]["nombre"]}"),
                              trailing: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                child: Container(
                                  width: 40,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: materiales[index]["estado"] ? Color(0xFF08ab7c) : Color(0xFFed5565), //Materiales normales
                                    //color: Color(0xFFed5565), //Materiales faltantes
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
                                  child: AutoSizeText(
                                    "${materiales[index]["cantidad"]}",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              onTap: (){},
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

                /*Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30
                      ),
                      child: new RaisedButton(
                        child: new Text(
                          'Solicitar Materiales',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        color: Colors.blue,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () {

                        },
                      ),
                    ),
                  ),
                )*/

                Visibility(
                  visible: visibleSolicitar,
                  child: Container(
                    padding: EdgeInsets.only(top: 0),
                    margin: EdgeInsets.only(left: 0, top: 0),
                    width: MediaQuery.of(context).size.width,
                    child: Divider( height: 0.5, color: Colors.black, ),
                  ),
                ),
                  
                Visibility(
                  visible: visibleSolicitar,
                  child: Container(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2
                        ),
                        child: ElevatedButton(
                            child: new AutoSizeText(
                              "Solicitar Materiales",
                              style: TextStyle(color: Colors.white, fontSize: 17,),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () {
                              if(falta_material && solicitoMaterial == 0){
                                solicitarMateriales();
                              }else{
                                print('No Puede Pedir Materiales');
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )
                              )
                            ),
                          ),
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),



      ),
    );
  }

  solicitarMateriales() async {
    //Probar
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?funcion=solicitarMateriales&codigoTecnico="+id;
    print(enlace);
    http.Response response = await http.get(Uri.parse(enlace));
    getMateriales();
    
    scaffoldMain.currentState.showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      content: new AutoSizeText("Materiales Solicitados.", 
        //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ), 
      duration: Duration(milliseconds: 2000),)
    );
  }
}
