import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/import_export/file%20processing/file_processing.dart';
import 'package:ultra_light_performance_tool/src/import_export/file%20selection/file_selection.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

///Defines the assistants mode
enum Mode{
  import, export
}

///Defines the phase in which the assistant currently is
enum Phase{
  optionsSelect, operation, finished, error
}

class _AssistantState{

  Phase phase;
  Mode mode;
  ///if true, will export/import settings to/from the .ulpt file
  bool withSettings;
  ///if not null, error phase will display this text.
  String? errorText;
  ///If opened directly from path, this path must be provided in the initial state!
  String? filePath;

  _AssistantState._({required this.phase, required this.mode, required this.withSettings, this.errorText, this.filePath});

  factory _AssistantState.initial({required Mode mode, String? filePath}){
    return _AssistantState._(phase: Phase.optionsSelect, mode: mode, withSettings: false, filePath: filePath);
  }

  copyWith({Phase? phase, Mode? mode, bool? withSettings, String? errorText,}){
    return _AssistantState._(
      phase: phase ?? this.phase,
      mode: mode ?? this.mode,
      withSettings: withSettings ?? this.withSettings,
      errorText: errorText ?? this.errorText,
      filePath: filePath,
    );
  }
}

class _AssistantCubit extends Cubit<_AssistantState>{
  _AssistantCubit({required Mode mode, String? filePath}) : super(_AssistantState.initial(mode: mode, filePath: filePath));

  ///If true will discard a new assistant build e.g. when tapping out and back to the app
  bool isFinished = false;

  @override
  void emit(_AssistantState state) {
    if (isClosed) return;
    super.emit(state);
  }

  ///Sets the export or import options
  void setOpsOptions({required bool withSettings}){
    emit(state.copyWith(phase: Phase.operation, withSettings: withSettings));
  }

  ///Starts whatever operation is associated with the current state selections
  Future<void> startOperation({required BuildContext context}) async{
    if(isFinished) return Navigator.pop(context);
    if(state.mode == Mode.import) return await _startFileImport(context: context);
    if(state.mode == Mode.export) return await _startFileExport(context: context);
    throw UnimplementedError();
  }

  Future<void> _startFileExport({required BuildContext context}) async{
    var appCubit = context.read<ApplicationCubit>();
    var dict = Localizer.of(context);
    try{
      var size = MediaQuery.of(context).size;
      var data = await ExportProcessor.createExportData(saveManager: appCubit.saveManager, exportSettings: state.withSettings);
      await ULPTFileExporter().exportULPTData(data: data, screenSize: size);
    } catch (e){
      //Todo log e
      return emit(state.copyWith(phase: Phase.error, errorText: dict.fileExportError));
    }finally{
      isFinished = true;
    }
    emit(state.copyWith(phase: Phase.finished));
  }

  Future<void> _startFileImport({required BuildContext context}) async{
    var appCubit = context.read<ApplicationCubit>();
    var dict = Localizer.of(context);
    
    try{
      var data = await ULPTFileImporter().importULPTData(dict: dict, filePath: state.filePath);
      if(data != null) {
        await ImportProcessor.processImportData(
            data: data,
            saveManager: appCubit.saveManager,
            importSettings: state.withSettings
        );
      }
    }catch (e){
      log(e.toString());
      return emit(state.copyWith(phase: Phase.error, errorText: dict.fileImportError));
    }finally{
      isFinished = true;
    }

    emit(state.copyWith(phase: Phase.finished));
  }
}

class ImportExportAssistant{
  static Future<void> startAssistant({required BuildContext context, required Mode mode, String? filePath}) async{
    await showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<_AssistantCubit>(
            create: (context) => _AssistantCubit(mode: mode, filePath: filePath),
            child: BlocBuilder<_AssistantCubit, _AssistantState>(
              builder: (context, state) {
                if(state.phase == Phase.optionsSelect) return _OptionsSelect(mode: state.mode,);
                if(state.phase == Phase.operation) return _Operation(mode: state.mode);
                if(state.phase == Phase.finished) return _Finished(mode: state.mode);
                if(state.phase == Phase.error && state.errorText != null) return _Error(errorText: state.errorText!);
                throw UnimplementedError("Not implemented");
              },
            ),
          );
        },
    );
  }

}

class _OptionsSelect extends StatelessWidget {
  const _OptionsSelect({required this.mode});

  final Mode mode;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;
    var textStyle = TextStyle(color: theme.interactiveFocusedColor);
    var buttonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(textStyle),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4,),
            OutlinedButton(
                style: buttonStyle,
                onPressed: () => context.read<_AssistantCubit>().setOpsOptions(withSettings: true),
                child: Text(
                  mode == Mode.export ?
                  Localizer.of(context).exportOptionSettings :
                  Localizer.of(context).importOptionSettings,
                  style: textStyle,
                )
            ),
            const SizedBox(width: 16,),
            OutlinedButton(
                style: buttonStyle,
                onPressed: () => context.read<_AssistantCubit>().setOpsOptions(withSettings: false),
                child: Text(
                  mode == Mode.export ?
                  Localizer.of(context).exportOptionNoSettings :
                  Localizer.of(context).importOptionNoSettings,
                  style: textStyle,
                )
            ),
            const SizedBox(width: 4,),
          ],
        );

        if(constraints.maxWidth < 580){
          content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                  style: buttonStyle,
                  onPressed: () => context.read<_AssistantCubit>().setOpsOptions(withSettings: true),
                  child: Text(
                    mode == Mode.export ?
                    Localizer.of(context).exportOptionSettings :
                    Localizer.of(context).importOptionSettings,
                    style: textStyle,
                  )
              ),
              const SizedBox(height: 8,),
              OutlinedButton(
                  style: buttonStyle,
                  onPressed: () => context.read<_AssistantCubit>().setOpsOptions(withSettings: false),
                  child: Text(
                    mode == Mode.export ?
                    Localizer.of(context).exportOptionNoSettings :
                    Localizer.of(context).importOptionNoSettings,
                    style: textStyle,
                  )
              ),
              const SizedBox(height: 8,),
            ],
          );
        }

        return IntrinsicWidth(
          child: SimpleDialog(
            title: Text(Localizer.of(context).optionsTitle , textAlign: TextAlign.center),
            children: [
              const SizedBox(height: 16,),
              content,
            ],
          ),
        );
      },
    );
  }
}

class _Operation extends StatelessWidget {
  const _Operation({
    required this.mode,
  });

  final Mode mode;

  @override
  Widget build(BuildContext context) {

    var title = "Operation in Progress";
    if(mode == Mode.export) title = Localizer.of(context).exportOperationTitle;
    if(mode == Mode.import) title = Localizer.of(context).importOperationTitle;

    context.read<_AssistantCubit>().startOperation(context: context);

    return IntrinsicWidth(
      child: SimpleDialog(
        title: Text(title, textAlign: TextAlign.center),
        children: const [
          SizedBox(height: 16,),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({required this.mode});

  final Mode mode;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;
    var textStyle = TextStyle(color: theme.interactiveFocusedColor);
    var buttonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(textStyle),
    );

    return IntrinsicWidth(
      child: SimpleDialog(
        title: Text(
            mode == Mode.import ?
            Localizer.of(context).importFinishedTitle :
            Localizer.of(context).exportFinishedTitle,
            textAlign: TextAlign.center
        ),
        children: [
          const SizedBox(height: 16,),
          Center(
            child: OutlinedButton(
                style: buttonStyle,
                onPressed: () => Navigator.pop(context),
                child: Text(Localizer.of(context).ok, style: textStyle,)
            ),
          ),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;
    var textStyle = TextStyle(color: theme.interactiveFocusedColor);
    var buttonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(textStyle),
    );

    return IntrinsicWidth(
      child: SimpleDialog(
        title: Text(errorText, textAlign: TextAlign.center),
        children: [
          const SizedBox(height: 16,),
          Center(
            child: OutlinedButton(
                style: buttonStyle,
                onPressed: () => Navigator.pop(context),
                child: Text(Localizer.of(context).ok, style: textStyle,)
            ),
          ),
        ],
      ),
    );
  }
}