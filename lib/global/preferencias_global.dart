import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static late SharedPreferences _prefs;

  static String _name = '';
  static String _apellido = '';
  static String _data_usuario = '';
  static String _grupo = '';
  static String _foto_usuario = '';
  static String _nombre_empresa = '';
  static String _foto_empresa = '';
  static String _data_id = '';
  static String _data_empresa = '';
  static String _moneda = '';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get apellido {
    return _prefs.getString('APELLIDO') ?? _apellido;
  }

  static set apellido(String apellido) {
    _apellido = apellido;
    _prefs.setString('APELLIDO', apellido);
  }

  static String get moneda {
    return _prefs.getString('MONEDA') ?? _moneda;
  }

  static set moneda(String moneda) {
    _moneda = moneda;
    _prefs.setString('MONEDA', moneda);
  }

  static String get name {
    return _prefs.getString('NOMBRE') ?? _name;
  }

  static set name(String name) {
    _name = name;
    _prefs.setString('NOMBRE', name);
  }

  static String get data_usuario {
    return _prefs.getString('DATA_USUARIO') ?? _data_usuario;
  }

  static set data_usuario(String data_usuario) {
    _data_usuario = data_usuario;
    _prefs.setString('DATA_USUARIO', data_usuario);
  }

  static String get foto_usuario {
    return _prefs.getString('FOTO_USUARIO') ?? _foto_usuario;
  }

  static set foto_usuario(String foto_usuario) {
    _foto_usuario = foto_usuario;
    _prefs.setString('FOTO_USUARIO', foto_usuario);
  }

  static String get nombre_empresa {
    return _prefs.getString('NOMBRE_EMPRESA') ?? _nombre_empresa;
  }

  static set nombre_empresa(String nombre_empresa) {
    _nombre_empresa = nombre_empresa;
    _prefs.setString('NOMBRE_EMPRESA', nombre_empresa);
  }

  static String get foto_empresa {
    return _prefs.getString('FOTO_EMPRESA') ?? _foto_empresa;
  }

  static set foto_empresa(String foto_empresa) {
    _foto_empresa = foto_empresa;
    _prefs.setString('FOTO_EMPRESA', foto_empresa);
  }

  static String get data_id {
    return _prefs.getString('DATA_ID') ?? _data_id;
  }

  static set data_id(String data_id) {
    _data_id = data_id;
    _prefs.setString('DATA_ID', data_id);
  }

  static String get data_empresa {
    return _prefs.getString('DATA_EMPRESA') ?? _data_empresa;
  }

  static set data_empresa(String data_empresa) {
    _data_empresa = data_empresa;
    _prefs.setString('DATA_EMPRESA', data_empresa);
  }

  static String get grupo {
    return _prefs.getString('GRUPO') ?? _grupo;
  }

  static set grupo(String grupo) {
    _grupo = grupo;
    _prefs.setString('GRUPO', grupo);
  }
}
