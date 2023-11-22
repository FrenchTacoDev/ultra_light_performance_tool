import 'package:flutter_test/flutter_test.dart';
import 'package:ultra_light_performance_tool/src/utils/input_utils.dart';

void main() {
  test('Input several strings and expect the temperature out of it', () async {
    expect(InputUtils.parseTemperature("15°C"), 15);
    expect(InputUtils.parseTemperature("°C14ccd658°--"), 14);
    expect(InputUtils.parseTemperature("°°°°ccCC°-33-778891456°°ccbd5568"), -33);
    expect(InputUtils.parseTemperature("-21"), -21);
  });

  test('Input several strings and expect the wind out of it', () async {
    var res = InputUtils.parseWind(input: "220/15", rwyCourse: 0);
    expect(res.direction == 220 && res.speed == 15, true);

    res = InputUtils.parseWind(input: "20", rwyCourse: 270);
    expect(res.direction == 270 && res.speed == 20, true);

    res = InputUtils.parseWind(input: "-31", rwyCourse: 270);
    expect(res.direction == 90 && res.speed == 31, true);

    expect(() => InputUtils.parseWind(input: "//2/256//20", rwyCourse: 0), throwsA(predicate((e) => e.toString() == "format exception")));
    expect(() => InputUtils.parseWind(input: "230//220", rwyCourse: 0), throwsA(predicate((e) => e.toString() == "format exception")));
    expect(() => InputUtils.parseWind(input: "230/-22", rwyCourse: 0), throwsA(predicate((e) => e.toString() == "format exception")));
    expect(() => InputUtils.parseWind(input: "-230/22", rwyCourse: 0), throwsA(predicate((e) => e.toString() == "invalid range")));

    res = InputUtils.parseWind(input: "310/12/20", rwyCourse: 0);
    expect(res.direction == 310 && res.speed == 12, true);
  });
}