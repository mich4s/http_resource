import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Model<T> {
  dynamic id;

  dynamic get identifier => this.id;

  HttpClient httpClient;

  Map<String, dynamic> setFields();

  Map<String, dynamic> get fields;

  Future<Model> create() async {
    return this.httpClient.create(this);
  }

  Future<Model> update() async {
    return this.httpClient.update(this);
  }
}

abstract class HttpClient<T extends Model> {
  String apiUrl = '';

  Map<String, dynamic> fields;

  Future<List<T>> all(
      {Map<String, dynamic> query, Map<String, String> headers}) {
    return http.get(apiUrl, headers: headers).then((http.Response response) {
      List<T> result = _parseList(json.decode(response.body));
      return result;
    });
  }

  Future<Model> first(id, {Map<String, String> headers}) {
    return http
        .get("$apiUrl/$id", headers: headers)
        .then((http.Response response) {
      return parseObject(json.decode(response.body));
    }).catchError((e) {
      return this.getInstance();
    });
  }

  Future<T> create(T instance, {Map<String, String> headers}) {
    return http
        .post("$apiUrl", headers: headers, body: json.encode(instance.fields))
        .then((http.Response response) {
      this._fillModelProperties(instance, json.decode(response.body));
      return instance;
    });
  }

  Future<T> update(T instance, {Map<String, String> headers}) {
    return http
        .put("$apiUrl/${instance.identifier}",
            headers: headers, body: json.encode(instance.fields))
        .then((http.Response response) {
      this._fillModelProperties(instance, json.decode(response.body));
      return instance;
    });
  }

  Future<T> delete(T instance, {Map<String, String> headers}) {
    return http
        .put("$apiUrl/${instance.identifier}",
            headers: headers, body: json.encode(instance.fields))
        .then((http.Response response) {
      this._fillModelProperties(instance, json.decode(response.body));
      return instance;
    });
  }

  T getInstance();

  T parseObject(Map<String, dynamic> body) {
    T t = this.getInstance();
    this._fillModelProperties(t, body);
    return t;
  }

  void _fillModelProperties(Model t, Map<String, dynamic> body) {
    body.forEach((String name, dynamic value) {
      var setter = t.setFields()[name];
      if (setter != null) setter(value);
    });
  }

  List<T> _parseList(List<dynamic> items) {
    return items.map((dynamic item) => this.parseObject(item)).toList();
  }
}
