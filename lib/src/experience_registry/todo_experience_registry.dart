import 'package:todo2_client/src/experience_registry/config/todo_list_experience_config.dart';
import 'package:wdesk_sdk/app_infrastructure.dart';
import 'package:wdesk_sdk/example_app_utilities.dart';
import 'package:wdesk_sdk/experience_framework.dart';
import 'package:wdesk_sdk/experiences.dart';

class TodoExperienceRegistry extends ExperienceRegistryV2 {
  TodoExperienceRegistry({bool isAutomated = true})
      : super.withExperienceConfigs(
            experienceConfigGroups: [TodoExperienceConfigGroup()],
            richExperiences: isAutomated ? [HarnessExperienceConfig()] : []);
}

class TodoExperienceConfigGroup extends ExperienceConfigGroup {
  @override
  List<DrawerExperienceConfig> get drawerExperiences =>
      [BasicDrawerExperienceConfig(), TodoListExperienceConfig()];
}
