import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:web_server/web_server.dart' as web_server;
import 'package:args/args.dart';

main(List<String> args) async {
  var parser = new ArgParser();
  parser.addFlag("release-mode");
  var argResults = parser.parse(args);

  var server = new web_server.WebServer(InternetAddress.ANY_IP_V4, 8080, hasHttpServer: true);

  if (argResults["release-mode"]) {
    //in release mode, we do a single pub build
    var executable = Platform.resolvedExecutable;

    var exitCode = await Process.start(executable,
        [path.join(path.dirname(executable), "snapshots", "pub.dart.snapshot"), "build"],
        workingDirectory: Platform.script.resolve("../../rpg_client").path).then((process) async {
      stderr.addStream(process.stderr);
      stdout.addStream(process.stdout);
      return process.exitCode;
    });

    if (exitCode != 0) {
      print("Pub build failed! Exiting...");
      exit(-1);
    } else {
      server.httpServerHandler.serveStaticVirtualDirectory(
          Platform.script.resolve("../../rpg_client/build/web").path,
          includeContainerDirNameInPath: false,
          prefixWithPseudoDirName: "static",
          shouldFollowLinks: true);
    }
  } else {
    runZoned(() {
      var executable = Platform.resolvedExecutable;

      Process.start(executable,
          [path.join(path.dirname(executable), "snapshots", "pub.dart.snapshot"), "serve", "--port=13234"],
          workingDirectory: Platform.script.resolve("../../rpg_client").path).then((process) async {
        stderr.addStream(process.stderr);
        stdout.addStream(process.stdout);
        await process.exitCode;
      });


      var client = new HttpClient();

      server.httpServerHandler.handleRequestsStartingWith(new web_server.UrlPath("/static")).listen((request) async {
        var clientRequest = await client.get("localhost", 13234, request.uri.pathSegments.skip(1).join("/"));
        clientRequest.cookies.addAll(request.cookies);

        request.headers.forEach(clientRequest.headers.set);

        var clientResponse = await clientRequest.close();

        clientResponse.headers.forEach(request.response.headers.set);

        request.response.statusCode = clientResponse.statusCode;

        clientResponse.listen(request.response.add, onDone: request.response.close);
      });
    }, onError: (err, stacktrace) {
      print(err);
      print(stacktrace);
    });
  }
}
