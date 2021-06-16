class JointMethods {
  Future<String> roomConvert(room) async {
    if (room.lastIndexOf('/') >= 0 && room.indexOf('?') >= 0) {
      return room.substring(room.lastIndexOf('/') + 1, room.indexOf('?'));
    } else if (room.lastIndexOf('/') >= 0 && room.indexOf('?') < 0) {
      return room.substring(room.lastIndexOf('/') + 1);
    } else if (room.lastIndexOf('/') < 0 && room.indexOf('?') >= 0) {
      return room.substring(0, room.indexOf('?'));
    } else {
      return room;
    }
  }
}
