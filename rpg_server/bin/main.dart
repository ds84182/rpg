import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:web_server/web_server.dart' as web_server;

main(List<String> args) {
  runZoned(() {
    var executable = Platform.resolvedExecutable;

    Process.start(executable,
        [path.join(path.dirname(executable), "snapshots", "pub.dart.snapshot"), "serve", "--port=13234"],
        workingDirectory: Platform.script.resolve("../../rpg_client").path).then((process) async {
      stderr.addStream(process.stderr);
      stdout.addStream(process.stdout);
      await process.exitCode;
    });

    var server = new web_server.WebServer(InternetAddress.ANY_IP_V4, 8080, hasHttpServer: true);
    var client = new HttpClient();

    server.httpServerHandler.registerDirectory(new web_server.UrlPath("/")).listen((request) async {
      var clientRequest = await client.get("localhost", 13234, request.uri.path);
      clientRequest.cookies.addAll(request.cookies);

      request.headers.forEach((name, values) {
        for (var str in values) {
          clientRequest.headers.add(name, str);
        }
      });

      var clientResponse = await clientRequest.close();

      clientResponse.headers.forEach((name, values) {
        for (var str in values) {
          request.response.headers.add(name, str);
        }
      });

      request.response.statusCode = clientResponse.statusCode;

      clientResponse.listen(request.response.add, onDone: request.response.close);
    });
  }, onError: (err, stacktrace) {
    print(err);
    print(stacktrace);
  });
}
