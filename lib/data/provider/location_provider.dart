import 'package:flutter/cupertino.dart';
import 'package:berikan/api/geolocation_api.dart';


enum ResultState { idle, loading, hasData, noData, error }
class LocationProvider extends ChangeNotifier{
  final ApiService apiService;
  final String locationArgument;

  LocationProvider(this.locationArgument, {required this.apiService}){
   getLatLang(locationArgument);
  }
  late Map<String, double> _latLangResult;
  ResultState _state = ResultState.idle;

  String _message = '';

  Map<String, double> get latLangResult => _latLangResult;
  ResultState get state => _state;
  String get message => _message;

Future<dynamic> getLatLang(String district) async{
  try{
    _state = ResultState.loading;
    notifyListeners();
    final result = await apiService.getLatLngFromDistrict(district);
    if (result == 'Sorry, but this location is not available yet on our map'){
      _state = ResultState.noData;
      notifyListeners();
      return _message = result;
    } else {
      _state = ResultState.hasData;
      notifyListeners();
      return _latLangResult = result;
    }
  } catch(e){
    _state = ResultState.error;
    notifyListeners();
    return _message = e.toString();
  }
}



}