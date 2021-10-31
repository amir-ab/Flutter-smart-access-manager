class Vehicle {

  String _id;
  String _number;

  Vehicle(this._id, this._number);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get number => _number;

  set number(String value) {
    _number = value;
  }


}