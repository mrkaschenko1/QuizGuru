Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    // ignore: unused_local_variable
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    // ignore: unused_local_variable
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
