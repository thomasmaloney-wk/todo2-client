import 'package:wdesk_sdk/experience_framework.dart';
import 'package:web_skin/src/icon_glyphs.dart';

import '../../experiences/todo_list_experience.dart' deferred as todo_list_lib;

class TodoListExperienceConfig extends DrawerExperienceConfig {
  @override
  Future<bool> canUserAccess(Provisioning provisioning) async => true;

  @override
  // TODO: implement displayName
  String get displayName => 'Todo List';

  @override
  // TODO: implement experienceFactory
  ExperienceFactory get experienceFactory =>
      todo_list_lib.todoListExperienceFactory;

  @override
  Future loadLibrary() async => todo_list_lib.loadLibrary();

  @override
  // TODO: implement navItemIcon
  IconGlyph get navItemIcon => IconGlyph.TWFR_ACTION_PLAN;

  @override
  // TODO: implement routeSegment
  String get routeSegment => 'todo-list';
}
