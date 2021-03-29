/*
import 'package:flutter/material.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
//import 'package:tecnicos_cm/pages/material_page.dart';

class OrdenPage extends StatefulWidget {
  OrdenPage({this.idOrden, this.direccionOrden, this.nombresApellidos, this.identificacionAbon, this.actividadNombre});
  final String idOrden;
  final String direccionOrden;
  final String nombresApellidos;
  final String identificacionAbon;
  final String actividadNombre;
  @override
  _OrdenPageState createState() => _OrdenPageState();
}

class MaterialModel{
  int idMaterial;
  String nombre;
  MaterialModel({this.idMaterial, this.nombre});
}

class ControlInventarioModel{
  int idMaterial;
  int cantControl;
  ControlInventarioModel(this.idMaterial);

  Map toJson() => {
    'idMaterial' : idMaterial,
    'cantControl' : cantControl,
  };
}

class _OrdenPageState extends State<OrdenPage> {

  String nombresAbon = '';
  String identidadAbon = '';
  String actividadOrden = '';
  int tamanioMateriales = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      identidadAbon = "Abonado: "+identificacionAbon;
      nombresAbon = "Nombres: "+nombresApellidos;
      actividadOrden = "Actividad: "+actividadNombre;
    });
    _obtenerMateriales();
  }

  //final _controlList = new List<ControlInventarioModel>();
  List<ControlInventarioModel> _controlList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text(direccionOrden),
          backgroundColor: Colors.black54,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: CloseButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/tab_page');
                },
              ),
            ),
          ],
        ),
        resizeToAvoidBottomPadding: false,
        body:
        Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height/1.3,
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
                Flexible(
                  flex: 1,
                  child: Container(
                      height: MediaQuery.of(context).size.height / 8.5,
                      width: MediaQuery.of(context).size.width /1.1,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0
                              ),
                              child: Text(
                                identidadAbon,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ), ),
                          Expanded(child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0
                              ),
                              child: Text(
                                nombresAbon,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ), ),
                          Expanded(child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top:0
                              ),
                              child: Text(
                                actividadOrden,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ), ),
                          Expanded(child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0
                              ),
                              child: Text(
                                actividadOrden,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ), ),

                        ],
                      )
                  ),
                ),
                Expanded(child: _crearListado(context),flex: 5,),

                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0
                      ),
                      child: new RaisedButton(
                        child: new Text(
                          'Finalizar Orden',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        color: Colors.blue,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () {
                          finalizarOrden();
                        },
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

  Widget _crearListado(BuildContext context){
    final _size = MediaQuery.of(context).size;

    return  Container(
        height: _size.height / 1.6,
        width: _size.width / 1.1,
        margin: EdgeInsets.only(top: 10),
        child:   Flexible(
          child: FutureBuilder(
            future: _obtenerMateriales(),
            builder: (BuildContext context, AsyncSnapshot<List<MaterialModel>> snapshot){
              if(snapshot.hasData){
                List<MaterialModel> materiales = snapshot.data;
                return Stack(
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: materiales.length,
                      itemBuilder: (context, i){
                        _controlList.add(
                            new ControlInventarioModel(materiales[i].idMaterial));
                        return _crearItem(context, materiales[i], i);
                      },
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
    );

  }

  Widget _crearItem(BuildContext context, MaterialModel material, int i){
    return Card(
      child: ListTile(
        title: Text('${material.nombre}',
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 15.0)),
        onTap: (){},
        trailing: _cajaNum(context, i, material.idMaterial),
      ),
    );
  }

  Widget _cajaNum(BuildContext context, int i, int idMaterial){
    return SizedBox(
      width: 100,
      child: Container(
        child: TextField(
          controller: TextEditingController()
            ..text = _controlList
                .firstWhere(
                    (element) => element.idMaterial == idMaterial)
                .cantControl ==
                null
                ? ''
                : _controlList
                .firstWhere((element) => element.idMaterial == idMaterial)
                .cantControl
                .toString(),
          onChanged: (value){
            _controlList[i].cantControl = int.parse(value);
          },
          onEditingComplete: (){
            FocusScope.of(context).unfocus();
          },
          onSubmitted: (value) {},
        ),
      ),
    );
  }

  Future<List<MaterialModel>> _obtenerMateriales() async{
    String id = codigoTecnico.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getMateriales.php/?codigoTecnico="+id;
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);
    List materiales = data['materiales'];
    var MyArray = [new MaterialModel( idMaterial: int.parse(materiales[0]['id_material']), nombre: materiales[0]['nombre'])];
    int tamanio = materiales.length;
    for(var i = 1; i < tamanio; i++){
      MaterialModel temp = new MaterialModel(idMaterial: int.parse(materiales[i]['id_material']), nombre: materiales[i]['nombre']);
      MyArray.add(temp);
    }

    tamanioMateriales = tamanio;

    return Future.delayed(
      Duration(seconds: 2),
          () => MyArray,
    );
  }

  Future finalizarOrden() async{
    //          "https://tecnicoscm.herokuapp.com/tecnico/tecnicos/pruebaDatos"
    //          "http://ns212.cablebox.co:5510/appmovil/postOrden.php"

    String jsonMateriales = "";
    var arrayP = [];
    for(int i = 0;i < tamanioMateriales; i++){
      if(i == (tamanioMateriales-1)){
        jsonMateriales += jsonEncode(_controlList[i]);
      }
      else{
        jsonMateriales += jsonEncode(_controlList[i]);
        jsonMateriales += ",";
      }
    }
    arrayP.add(jsonMateriales);
    String ultimo = arrayP.toString();

    http.Response response = await http.post("http://ns212.cablebox.co:5510/appmovil/postOrden.php",
        body: {
          "username":ultimo
        });

    var datauser = json.decode(response.body);
    print(datauser);

    Navigator.pushReplacementNamed(context, "/tab_page");
  }

}






Expanded(
                    child: Container(
                      child: Card(
                        child: ListTile(
                          title: Text('CABLEMODEM',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor, fontSize: 15.0)
                          ),
                          trailing: SizedBox(
                            width: 150,
                            child: Container(
                              child: DropdownButton<Item>(
                                hint: Text("Cablemodem"),
                                value: valorElegido,
                                onChanged: (Item newValue){
                                  setState(() {
                                    valorElegido = newValue;
                                  });
                                },
                                items: selectList.map((Item valueItem) {
                                  return DropdownMenuItem<Item>(
                                    value: valueItem,
                                    child: Text(valueItem.mac, style:  TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                              )
                            ),
                          ),
                        ),
                      ),
                    )
                ),

 */