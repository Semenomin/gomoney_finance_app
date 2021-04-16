import 'package:http/io_client.dart';
import 'package:http/http.dart';

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
}
