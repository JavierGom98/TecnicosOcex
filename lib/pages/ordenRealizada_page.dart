import 'package:flutter/material.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/ordenesRealizadas_page.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class OrdenRealizadaPage extends StatefulWidget {
  OrdenRealizadaPage({this.idOrden, this.direccionOrden, this.nombresApellidos, this.identificacionAbon, this.actividadNombre});
  final String idOrden;
  final String direccionOrden;
  final String nombresApellidos;
  final String identificacionAbon;
  final String actividadNombre;
  @override
  _OrdenRealizadaPageState createState() => _OrdenRealizadaPageState();
}

class MaterialModel{
  int idMaterial;
  String nombre;
  String cantidadUsada;
  MaterialModel({this.idMaterial, this.nombre, this.cantidadUsada});
}

class ControlInventarioModel{
  int idMaterial;
  String cantControl;
  ControlInventarioModel(this.idMaterial, this.cantControl);

  Map toJson() => {
    'idMaterial' : idMaterial,
    'cantControl' : cantControl,
  };
}

class Item{
  int idCablemodem;
  String mac;
  Item({this.idCablemodem, this.mac});
}

class _OrdenRealizadaPageState extends State<OrdenRealizadaPage> {

  String nombresAbon = '';
  String identidadAbon = '';
  String actividadOrden = '';
  int tamanioMateriales = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      identidadAbon = "Abonado: " + identificacionAbonR;
      nombresAbon = "Nombres: " + nombresApellidosR;
      actividadOrden = "Actividad: " + actividadNombreR;
    });
    _obtenerMateriales();
  }

  List<ControlInventarioModel> _controlList = [];

  Item valorElegido;
  List<Item> selectList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text(direccionOrdenR),
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
            width: MediaQuery.of(context).size.width / 1.5,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      //padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            //alignment: Alignment.centerLeft,
                            child: Text(identidadAbon, style: TextStyle(fontSize: 15),),
                          ),
                          Align(
                            //alignment: Alignment.centerLeft,
                            child: Text(nombresAbon, style: TextStyle(fontSize: 15),),
                          ),
                          Align(
                            //alignment: Alignment.centerLeft,
                            child: Text(actividadOrden, style: TextStyle(fontSize: 15),),
                          ),
                          Align(
                            //alignment: Alignment.centerLeft,
                            child: Text(identidadAbon, style: TextStyle(fontSize: 15),),
                          ),
                        ],
                      ),
                    )
                ),

                Expanded(flex: 8,child: _crearListado(context)),

              ],
            ),

          ),
        )

    );
  }

  Widget _crearListado(BuildContext context){
    return  Container(
      margin: EdgeInsets.only(top: 10),
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
                        new ControlInventarioModel(materiales[i].idMaterial, materiales[i].cantidadUsada));
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
      width: 130,
      child: Container(
        child: TextField(
          enabled: false,
          focusNode: FocusNode(),
          enableInteractiveSelection: false,
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
        ),
      ),
    );
  }

  Future<List<MaterialModel>> _obtenerMateriales() async{
    String id = idOrdenR.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getMaterialesOrdenR.php/?idOrden="+id;
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);
    //print(data);

    List materiales = data['materiales'];

    var MyArray = [new MaterialModel( idMaterial: int.parse(materiales[0]['id_material']), nombre: materiales[0]['nombre'], cantidadUsada: materiales[0]['cantidad'])];
    int tamanio = materiales.length;
    for(var i = 1; i < tamanio; i++){
      MaterialModel temp = new MaterialModel(idMaterial: int.parse(materiales[i]['id_material']), nombre: materiales[i]['nombre'], cantidadUsada: materiales[i]['cantidad']);
      MyArray.add(temp);
    }
    tamanioMateriales = tamanio;

    return Future.delayed(
      Duration(seconds: 2),
          () => MyArray,
    );
  }

}
