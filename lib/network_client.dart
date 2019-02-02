import 'dart:convert' show Encoding;
import 'package:http/http.dart';

typedef Future<Request> RequestInterceptor(Request request);
typedef Future<Response> ResponseInterceptor(Response response);

class NetworkClient extends BaseClient {
  final Client _inner;
  final List<RequestInterceptor> _requestInterceptors;
  final List<ResponseInterceptor> _responseInterceptors;

  NetworkClient([Client client])
      : _inner = client != null ? client : new Client(),
        _requestInterceptors = [],
        _responseInterceptors = [];

  void registerRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  void registerResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.add(interceptor);
  }

  ///
  ///
  ///
  @override
  Future<Response> get(
    url, {
    Map<String, String> headers,
  }) async {
    final resp = await super.get(url, headers: headers);
    final updatedResp = await _handleResponseInterceptors(resp);
    return updatedResp;
  }

  ///
  ///
  ///
  @override
  Future<Response> post(
    url, {
    Map<String, String> headers,
    body,
    Encoding encoding,
  }) async {
    final resp =
        await super.post(url, headers: headers, body: body, encoding: encoding);
    final updatedResp = await _handleResponseInterceptors(resp);
    return updatedResp;
  }

  ///
  ///
  ///
  @override
  Future<Response> patch(
    url, {
    Map<String, String> headers,
    body,
    Encoding encoding,
  }) async {
    final resp = await super
        .patch(url, headers: headers, body: body, encoding: encoding);
    final updatedResp = await _handleResponseInterceptors(resp);
    return updatedResp;
  }

  ///
  ///
  ///
  @override
  Future<Response> delete(
    url, {
    Map<String, String> headers,
  }) async {
    final resp = await super.delete(url, headers: headers);
    final updatedResp = await _handleResponseInterceptors(resp);
    return updatedResp;
  }

  ///
  ///
  ///
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    Request reqBuf = request;
    if (_requestInterceptors.length > 0) {
      for (final interceptor in _requestInterceptors) {
        reqBuf = await interceptor(reqBuf);
      }
    }
    return await _inner.send(reqBuf);
  }

  ///
  ///
  ///
  Future<Response> _handleResponseInterceptors(Response response) async {
    Response resBuf = response;
    if (_responseInterceptors.length > 0) {
      for (final interceptor in _responseInterceptors) {
        resBuf = await interceptor(resBuf);
      }
    }
    return resBuf;
  }
}
