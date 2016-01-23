import 'dart:io';
import 'package:path/path.dart' as path;

main(List<String> args) {
  var executable = Platform.resolvedExecutable;

  Process.start(executable,
      [path.join(path.dirname(executable), "snapshots", "pub.dart.snapshot"), "serve"],
      workingDirectory: Platform.script.resolve("../../rpg_client").path).then((process) {
    stderr.addStream(process.stderr);
    stdout.addStream(process.stdout);
  });
}
