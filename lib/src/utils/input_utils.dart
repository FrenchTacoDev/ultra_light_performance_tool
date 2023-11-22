class InputUtils{

  ///parses a string of temperature in degrees celsius to a number
  static int? parseTemperature(String inputString) {
    final temperatureMatch = RegExp(r'(-?\d+)[°cC]?').firstMatch(inputString);
    if(temperatureMatch == null) return null;
    if(temperatureMatch.group(1) == null) return null;
    return int.tryParse(temperatureMatch.group(1)!);
  }

  ///parses a string of wind into direction and speed parameters
  static ({int direction, int speed}) parseWind({required String input, required int rwyCourse}) {
    assert(rwyCourse >= 0 && rwyCourse <= 360);

    final match = RegExp(r'^(-?\d+)(?:/(\d+))?(?:/(\d+))?$').firstMatch(input);
    if(match == null) throw WindFormatError();
    final parts = input.split("/");

    var direction = int.tryParse(parts[0]);
    if(direction == null) throw WindFormatError();
    var speed = int.tryParse(parts.length > 1 ? parts[1] : "0");
    if(speed == null) throw WindFormatError();

    if(parts.length == 1){
      speed = direction;
      direction = speed >= 0 ? rwyCourse : (rwyCourse + 180) % 360;
      speed = speed.abs();
    }

    if(direction > 360 || direction < 0) throw WindDirectionError();
    if(speed < 0) throw WindSpeedError();

    return (direction: direction, speed: speed);
  }
}

class WindFormatError extends Error{
  @override
  String toString() => "WindFormatError";
}

class WindDirectionError extends Error{
  @override
  String toString() => "WindDirectionError";
}

class WindSpeedError extends Error{
  @override
  String toString() => "WindSpeedError";
}