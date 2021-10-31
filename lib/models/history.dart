class History {

  String _id;
  String _entry;
  String _exit;
  String _vehicle;

  History(this._id, this._entry, this._exit, this._vehicle);

  String get vehicle => _vehicle;

  set vehicle(String value) {
    _vehicle = value;
  }

  String get exit => _exit;

  set exit(String value) {
    _exit = value;
  }

  String get entry => _entry;

  set entry(String value) {
    _entry = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}