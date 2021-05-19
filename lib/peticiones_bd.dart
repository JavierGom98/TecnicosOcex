import 'package:tecnicos_cm/main.dart';
import 'package:http/http.dart' as http;

Future<String> getOrdenesBD() async {
  String id = codigoTecnico.toString();
  String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getOrdenes.php?codigoTecnico="+id;
  http.Response response = await http.get(Uri.parse(enlace));
  return response.body;
}

Future<String> getFechaInicio(idOrden) async {
  String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?idOrden="+idOrden+"&funcion=getFechaInicio";
  http.Response response = await http.get(Uri.parse(enlace));
  return response.body;
}