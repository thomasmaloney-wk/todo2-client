import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo2_client/src/components/create_todo_input.dart';

main() {
  group('CreateTodoInput', () {
    test('renders a Form with correct props', () {
      var jacket = mount(CreateTodoInput()());
      var instance = jacket.getInstance();
      var formProps = Form(getPropsByTestId(instance, 'createTodoInput.form'));

      expect(formProps.className, 'create-todo-input');
      expect(formProps.onSubmit, isNotNull);
    });
  });
}
