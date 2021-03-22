import 'dart:async';
import 'dart:html';

import 'package:eventsource/eventsource.dart';
import 'package:http/browser_client.dart';
import 'package:sse_client/src/sse_client.dart';

class HtmlSseClient extends SseClient {
  HtmlSseClient(Stream stream) : super(stream: stream);

  factory HtmlSseClient.connect(Uri uri,
      {Map<String, String>? headers, bool withCredentials = false}) {
    final incomingController = StreamController<String?>();

    EventSource.connect(uri.toString(),
            client: BrowserClient(), headers: headers)
        .then((_eventSource) {
      _eventSource.asBroadcastStream().listen((event) {
        incomingController.add((event as MessageEvent).data as String?);
      });
    });

    return HtmlSseClient(incomingController.stream);
  }
}
