class NavigationState {
  final bool? _unknown;
  final bool? _taskForm;

  int? selectedTaskId;

  bool get isTaskForm => _taskForm == true;

  bool get isMainScreen => _taskForm == false;

  bool get isUnknown => _unknown == true;

  NavigationState.mainScreen()
      : _unknown = false,
        _taskForm = false,
        selectedTaskId = null;

  NavigationState.taskForm(this.selectedTaskId)
      : _unknown = false,
        _taskForm = true;

  NavigationState.unknown()
      : _unknown = true,
        _taskForm = false,
        selectedTaskId = null;
}
