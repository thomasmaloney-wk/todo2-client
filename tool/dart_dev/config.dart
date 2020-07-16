import 'dart:io';

import 'package:dart_dev/dart_dev.dart';
import 'package:dart_dev_workiva/dart_dev_workiva.dart';
import 'package:glob/glob.dart';
import 'package:over_react_format/dart_dev_tool.dart';

import '../gen_tests.dart';

List<Glob> excludedFromGeneration = _getGeneratedFiles();

final Map<String, DevTool> config = {
  ...workivaConfig,
  'analyze': TuneupCheckTool()..ignoreInfos = true,
  'format': OverReactFormatTool()
    ..lineLength = 80
    ..exclude = excludedFromGeneration,
  //'test': TestTool()..buildArgs = ['--delete-conflicting-outputs']
  'test': CompoundTool()
    ..addTool(GenTestRunner())
    ..addTool(TestTool()..buildArgs = ['--delete-conflicting-outputs'],
        argMapper: takeAllArgs)
};

bool _isGenerated(String path) =>
    path.endsWith('.g.dart') || path.endsWith('generated_runner_test.dart');

List<Glob> _getGeneratedFiles() {
  return _getGeneratedFilesIn('lib/')
    ..addAll(_getGeneratedFilesIn('tool/'))
    ..addAll(_getGeneratedFilesIn('test/'));
}

List<Glob> _getGeneratedFilesIn(String path) => Directory(path)
    .listSync(recursive: true, followLinks: false)
    .where((entity) => entity is File && _isGenerated(entity.path))
    .map((entity) => Glob(entity.path))
    .toList();
