import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

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
  int cantidadMinima;
  MaterialModel({this.idMaterial, this.nombre, this.cantidadMinima});
}

class ControlInventarioModel{
  int idMaterial;
  int cantControl;
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
    _obtenerCablemodems();
  }

  List<ControlInventarioModel> _controlList = [];

  Item valorElegido;
  List<Item> selectList;

  List<Offset> points = [];

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

                Expanded(child: _crearSelect(context)),

                Expanded(flex: 6,child: _crearListado(context)),

                Expanded(
                  flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width/ 1.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onPanDown: (details){
                          this.setState(() {
                            points.add(details.localPosition);
                          });
                        },
                        onPanUpdate: (details){
                          this.setState(() {
                            points.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details){
                          this.setState(() {
                            points.add(null);
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(points: points),
                          ),
                        ),
                      ),
                  )
                ),

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
                          new ControlInventarioModel(materiales[i].idMaterial, materiales[i].cantidadMinima));
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
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getMaterialesOrden.php/?codigoTecnico="+id;
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);
    List materiales = data['materiales'];

    var MyArray = [new MaterialModel( idMaterial: int.parse(materiales[0]['id_material_tecnico']), nombre: materiales[0]['nombre'], cantidadMinima: int.parse(materiales[0]['cantidadMinimaOrden']))];
    int tamanio = materiales.length;
    for(var i = 1; i < tamanio; i++){
      MaterialModel temp = new MaterialModel(idMaterial: int.parse(materiales[i]['id_material_tecnico']), nombre: materiales[i]['nombre'], cantidadMinima: int.parse(materiales[i]['cantidadMinimaOrden']));
      MyArray.add(temp);
    }
    tamanioMateriales = tamanio;

    return Future.delayed(
      Duration(seconds: 2),
        () => MyArray,
    );
  }


  Widget _crearSelect(BuildContext context){
    return
      Container(
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
                  hint: Text("Seleccione"),
                  value: valorElegido,
                  onChanged: (Item newValue){
                    setState(() {
                      valorElegido = newValue;
                    });
                  },
                  items: selectList?.map((Item valueItem) {
                    return new DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.mac, style:  TextStyle(color: Colors.black)),
                    );
                  })?.toList() ??
                  [],
                )
            ),
          ),
        ),
      ),
    );



  }

  Future<List<Item>> _obtenerCablemodems() async{
    String id = codigoTecnico.toString();
    String enlace = "http://ns212.cablebox.co:5510/appmovil/getCablemodemsOrden.php/?codigoTecnico="+id;
    http.Response response = await http.get(enlace);
    var data = json.decode(response.body);

    List cablemodems = data['cablemodems'];
    var MyArray = [new Item(idCablemodem: int.parse(cablemodems[0]['idCablemodem']), mac: cablemodems[0]['mac'])];
    int tamanio = cablemodems.length;
    for(var i = 1; i < tamanio; i++){
      Item temp = new Item(idCablemodem: int.parse(cablemodems[i]['idCablemodem']), mac: cablemodems[i]['mac']);
      MyArray.add(temp);
    }

    setState(() {
      selectList = MyArray;
    });
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
    print(ultimo);
    print(idOrden);
    print(valorElegido.idCablemodem);

    http.Response response = await http.post("http://ns212.cablebox.co:5510/appmovil/postOrden.php",
        body: {
          "materialesUsados":ultimo,
          "cablemodemUsado": valorElegido.idCablemodem.toString(),
          "idOrdenAfiliacion" : idOrden
        });

    var datauser = json.decode(response.body);

    print(datauser);
    if(datauser['ok'] == 'Orden Finalizada Correctamente'){
      Navigator.pushReplacementNamed(context, "/tab_page");
    }

  }

}

class MyCustomPainter extends CustomPainter{

  List<Offset> points;

  MyCustomPainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    for(int x = 0; x<points.length-1; x++){
      if(points[x] != null && points[x+1] != null){
        canvas.drawLine(points[x], points[x+1], paint);
      } else if(points[x] != null && points[x+1] == null){
        canvas.drawPoints(PointMode.points, [points[x]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
  
}
