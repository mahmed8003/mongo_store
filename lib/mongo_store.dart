library mongo_store;

import 'dart:convert' show json;

import 'package:meta/meta.dart';

import 'package:network_client/network_client.dart';


class MongoStoreException implements Exception {
  MongoStoreException.fromMap(Map<String, dynamic> data)
      : statusCode = data['statusCode'],
        error = data['error'],
        message = data['message'];

  final int statusCode;
  final String error;
  final String message;
}

class PopulateOptions {
  /// space delimited path(s) to populate
  final String path;

  /// optional fields to select
  final String select;

  /// optional query conditions to match
  final Map<String, dynamic> match;

  /// optional name of the model to use for population
  final String model;

  /// optional query options like sort, limit, etc
  final Map<String, dynamic> options;

  /// deep populate
  final List<PopulateOptions> populate;

  PopulateOptions({
    this.path,
    this.select,
    this.match,
    this.model,
    this.options,
    this.populate,
  });

  Map<String, dynamic> toMap() {}
}

class MongoStore {
  final String baseUrl;
  final String prefix;
  final String version;
  final Map<String, String> headers;

  NetworkClient _client;

  MongoStore.connect(
    this.baseUrl, {
    this.prefix = '',
    this.version = '',
    this.headers = const {},
  }) : _client = new NetworkClient();

  void registerRequestInterceptor(RequestInterceptor interceptor) {
    _client.registerRequestInterceptor(interceptor);
  }

  void registerResponseInterceptor(ResponseInterceptor interceptor) {
    _client.registerResponseInterceptor(interceptor);
  }

  Future<Map<String, dynamic>> findById({
    @required String collection,
    @required String id,
    final String select,
    final Map<String, int> selectMap,
    final String populate,
    final PopulateOptions populateWithOptions,
    final List<PopulateOptions> populateMultipleWithOptions,
    final bool lean,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    if (populate != null) {
      queryParams['populate'] = populate;
    } else if (populateWithOptions != null) {
      queryParams['populate'] = json.encode(populateWithOptions.toMap());
    } else if (populateMultipleWithOptions != null) {
      queryParams['populate'] = json.encode(
          populateMultipleWithOptions.map((opt) => opt.toMap()).toList());
    }

    if (lean != null) {
      queryParams['lean'] = lean.toString();
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection/$id';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findOneData(url);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> findOne({
    @required String collection,
    @required Map<String, dynamic> query,
    final String select,
    final Map<String, int> selectMap,
    final String populate,
    final PopulateOptions populateWithOptions,
    final List<PopulateOptions> populateMultipleWithOptions,
    final String sort,
    final Map<String, int> sortMap,
    final int skip,
    final int limit,
    final String distinct,
    final bool lean,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    queryParams['query'] = json.encode(query);

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    if (populate != null) {
      queryParams['populate'] = populate;
    } else if (populateWithOptions != null) {
      queryParams['populate'] = json.encode(populateWithOptions.toMap());
    } else if (populateMultipleWithOptions != null) {
      queryParams['populate'] = json.encode(
          populateMultipleWithOptions.map((opt) => opt.toMap()).toList());
    }

    if (sort != null) {
      queryParams['sort'] = sort;
    } else if (sortMap != null) {
      queryParams['sort'] = json.encode(sortMap);
    }

    if (skip != null) {
      queryParams['skip'] = skip.toString();
    }

    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    if (distinct != null) {
      queryParams['distinct'] = distinct;
    }

    if (lean != null) {
      queryParams['lean'] = lean.toString();
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection/one';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findOneData(url);
    return data;
  }

  ///
  ///
  ///
  Future<List<dynamic>> findMany({
    @required String collection,
    @required Map<String, dynamic> query,
    final String select,
    final Map<String, int> selectMap,
    final String populate,
    final PopulateOptions populateWithOptions,
    final List<PopulateOptions> populateMultipleWithOptions,
    final String sort,
    final Map<String, int> sortMap,
    final int skip,
    final int limit,
    final String distinct,
    final bool lean,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    queryParams['query'] = json.encode(query);

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    if (populate != null) {
      queryParams['populate'] = populate;
    } else if (populateWithOptions != null) {
      queryParams['populate'] = json.encode(populateWithOptions.toMap());
    } else if (populateMultipleWithOptions != null) {
      queryParams['populate'] = json.encode(
          populateMultipleWithOptions.map((opt) => opt.toMap()).toList());
    }

    if (sort != null) {
      queryParams['sort'] = sort;
    } else if (sortMap != null) {
      queryParams['sort'] = json.encode(sortMap);
    }

    if (skip != null) {
      queryParams['skip'] = skip.toString();
    }

    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    if (distinct != null) {
      queryParams['distinct'] = distinct;
    }

    if (lean != null) {
      queryParams['lean'] = lean.toString();
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findManyData(url);
    return data;
  }

  ///
  ///
  ///
  Future<void> createDocument({
    @required String collection,
    @required Map<String, dynamic> payload,
    final bool safe,
    final bool validateBeforeSave,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    if (safe != null) {
      queryParams['safe'] = safe.toString();
    }

    if (validateBeforeSave != null) {
      queryParams['validateBeforeSave'] = validateBeforeSave.toString();
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _createData(url, payload);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> findByIdAndUpdate({
    @required String collection,
    @required String id,
    @required Map<String, dynamic> payload,
    final bool returnNew,
    final bool upsert,
    final bool runValidators,
    final String select,
    final Map<String, int> selectMap,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    if (returnNew != null) {
      queryParams['new'] = returnNew.toString();
    }

    if (upsert != null) {
      queryParams['upsert'] = upsert.toString();
    }

    if (runValidators != null) {
      queryParams['runValidators'] = runValidators.toString();
    }

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection/$id';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findOneAndUpdateData(url, payload);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> findOneAndUpdate({
    @required String collection,
    @required Map<String, dynamic> query,
    @required Map<String, dynamic> payload,
    final bool returnNew,
    final bool upsert,
    final bool runValidators,
    final String select,
    final Map<String, int> selectMap,
    final String sort,
    final Map<String, int> sortMap,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    queryParams['query'] = json.encode(query);

    if (returnNew != null) {
      queryParams['new'] = returnNew.toString();
    }

    if (upsert != null) {
      queryParams['upsert'] = upsert.toString();
    }

    if (runValidators != null) {
      queryParams['runValidators'] = runValidators.toString();
    }

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    if (sort != null) {
      queryParams['sort'] = sort;
    } else if (sortMap != null) {
      queryParams['sort'] = json.encode(sortMap);
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection/one';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findOneAndUpdateData(url, payload);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> updateMany({
    @required String collection,
    @required Map<String, dynamic> query,
    @required Map<String, dynamic> payload,
    final bool safe,
    final bool upsert,
    final bool multi,
    final bool runValidators,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    queryParams['query'] = json.encode(query);

    if (safe != null) {
      queryParams['safe'] = safe.toString();
    }

    if (upsert != null) {
      queryParams['upsert'] = upsert.toString();
    }

    if (multi != null) {
      queryParams['multi'] = multi.toString();
    }

    if (runValidators != null) {
      queryParams['runValidators'] = runValidators.toString();
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findOneAndUpdateData(url, payload);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> findByIdAndDelete({
    @required String collection,
    @required String id,
    final String select,
    final Map<String, int> selectMap,
    final String sort,
    final Map<String, int> sortMap,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    if (sort != null) {
      queryParams['sort'] = sort;
    } else if (sortMap != null) {
      queryParams['sort'] = json.encode(sortMap);
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection/$id';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findAndDelete(url);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> findOneAndDelete({
    @required String collection,
    @required Map<String, dynamic> query,
    final String select,
    final Map<String, int> selectMap,
    final String sort,
    final Map<String, int> sortMap,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    queryParams['query'] = json.encode(query);

    if (select != null) {
      queryParams['select'] = select;
    } else if (selectMap != null) {
      queryParams['select'] = json.encode(selectMap);
    }

    if (sort != null) {
      queryParams['sort'] = sort;
    } else if (sortMap != null) {
      queryParams['sort'] = json.encode(sortMap);
    }

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection/one';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findAndDelete(url);
    return data;
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> deleteMany({
    @required String collection,
    @required Map<String, dynamic> query,
    final String prefix,
    final String version,
  }) async {
    final Map<String, String> queryParams = {};

    queryParams['query'] = json.encode(query);

    // Create Url
    final tPrefix = prefix ?? this.prefix;
    final tVersion = version ?? this.version;
    String url = '$baseUrl$tPrefix$tVersion/$collection';
    if (queryParams.isNotEmpty) {
      url = '?${_encodeMap(queryParams)}';
    }

    final data = await _findAndDelete(url);
    return data;
  }

  Future<Map<String, dynamic>> _findOneData(String url) async {
    final resp = await _client.get(url, headers: _getHeaders());
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      return respBody;
    } else {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      final e = MongoStoreException.fromMap(respBody);
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> _findManyData(String url) async {
    final resp = await _client.get(url, headers: _getHeaders());
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final List<Map<String, dynamic>> respBody = json.decode(resp.body);
      return respBody;
    } else {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      final e = MongoStoreException.fromMap(respBody);
      throw e;
    }
  }

  Future<Map<String, dynamic>> _createData(
    String url,
    Map<String, dynamic> payload,
  ) async {
    final body = json.encode(payload);
    final resp = await _client.post(
      url,
      headers: _getHeaders(),
      body: body,
    );
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      return respBody;
    } else {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      final e = MongoStoreException.fromMap(respBody);
      throw e;
    }
  }

  Future<Map<String, dynamic>> _findOneAndUpdateData(
    String url,
    Map<String, dynamic> payload,
  ) async {
    final resp =
        await _client.patch(url, headers: _getHeaders(), body: payload);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      return respBody;
    } else {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      final e = MongoStoreException.fromMap(respBody);
      throw e;
    }
  }

  Future<Map<String, dynamic>> _findAndDelete(String url) async {
    final resp = await _client.delete(url, headers: _getHeaders());
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      return respBody;
    } else {
      final Map<String, dynamic> respBody = json.decode(resp.body);
      final e = MongoStoreException.fromMap(respBody);
      throw e;
    }
  }

  Map<String, String> _getHeaders() {
    final Map<String, String> headers = new Map<String, String>();
    headers.addAll(this.headers);
    headers['Accept'] = 'application/json';
    headers['Content-Type'] = 'application/json';
    return headers;
  }
}

String _encodeMap(Map<String, String> data) {
  return data.keys
      .map((key) => '$key=${Uri.encodeComponent(data[key])}')
      .join("&");
}
