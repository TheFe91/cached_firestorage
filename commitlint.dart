import 'dart:io';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.write('Error: empty commit message');
    exit(2);
  }

  final RegExp regExp = RegExp(r'^(feat|fix|docs|style|refactor|perf|test|chore|revert)(\(.+\))?: .{1,72}$');
  final String commitmessage = arguments.first;
  if (regExp.hasMatch(commitmessage)) {
    exit(0);
  }

  stdout.write('Error: your commit message `$commitmessage` does not comply with the required format');
  exit(1);
}
