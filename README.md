Ultra Light Performance Tool -> Short ULPT is an open source tool for pilots and students on ultra light aircraft.
It is meant to be used as an advisory and guidance tool for the performance calculation under different circumstances.

UL-Pilots can use this tool to determine a calculated takeoff distance, given their entries on aircraft data and environmental conditions.
The use of this tool does not relief the Pilot in Command from consulting the aircraft's manual and appropiate documentation.
The tool uses estimated and interpolated values only and is therefore just for information.
The liability lies solely with the Pilot in Command.

If you'd like to contirbute to this project, please open a pull-request or send me a message asking what you could do to help out.

## Getting started

Add the current dependency to your Flutter project in your pubspec.yaml file:

```yaml
  ultra_light_performance_tool:
    git: https://github.com/FrenchTacoDev/ultra_light_performance_tool.git
```

## Usage

Add the ULPT Widget to your App or your main method.

```dart
void main() {

  //This is needed to setup SQLite FFI so the database library can work on desktop!
  if(io.Platform.isWindows ||io.Platform.isMacOS){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ULPT());
}
```

## Additional information

ULPT is meant to be an open source / free to use prodcut.
It will be published free of charge to the respective stores.

If you want to publish your own version, please feel free.
However we would love you to contribute here to further enhance the project.
