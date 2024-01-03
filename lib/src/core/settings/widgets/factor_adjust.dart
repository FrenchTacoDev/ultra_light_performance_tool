import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';
import 'factor_adjust_field.dart';

///Panel that is used by the user to adjust the factors for the performance calculation
///Should be made accessible on the settings page.
class FactorAdjustPanel extends StatelessWidget {
  const FactorAdjustPanel({super.key, this.corrections});

  final Corrections? corrections;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<FactorAdjustCubit>(
        create: (context) => FactorAdjustCubit(corrections: corrections),
        child: BlocBuilder<FactorAdjustCubit, FactorAdjustState>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: BackButton(onPressed: (){
                    Navigator.pop(context, state.corrections);
                  }),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Tooltip(
                        message: Localizer.of(context).reset,
                        child: IconButton(
                            onPressed: () => context.read<FactorAdjustCubit>().reset(),
                            icon: const Icon(Icons.restart_alt_outlined),
                        ),
                      ),
                    ),
                  ],
                  title: Text(Localizer.of(context).facAdjustTitle),
                ),
                body: Padding(
                    padding: Platform.isIOS ? const EdgeInsets.fromLTRB(16, 16, 16, 24) :
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Card(
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(Localizer.of(context).faWindTitle, textAlign: TextAlign.center),
                                  titleAlignment: ListTileTitleAlignment.center,
                                ),
                                Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faHw,
                                  value: ((state.corrections.headWindFactor - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustHeadwindFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faTw,
                                  value: ((state.corrections.tailWindFactor - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustTailwindFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  title: Text(Localizer.of(context).faGrassTitle, textAlign: TextAlign.center),
                                  titleAlignment: ListTileTitleAlignment.center,
                                ),
                                Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faGrassFirm,
                                  value: ((state.corrections.grassFactorFirm - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustGrassFirmFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faGrassWet,
                                  value: ((state.corrections.grassFactorWet - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustGrassWetFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faGrassSoftened,
                                  value: ((state.corrections.grassFactorSoftened - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustGrassSoftenedFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faGrassSodDamaged,
                                  value: ((state.corrections.sodDamagedFactor - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustSodDamagedFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faGrassHigh,
                                  value: ((state.corrections.highGrassFactor - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustHighGrassFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  title: Text(Localizer.of(context).faConditionTitle, textAlign: TextAlign.center),
                                  titleAlignment: ListTileTitleAlignment.center,
                                ),
                                Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faConWet,
                                  value: ((state.corrections.conditionFactorWet - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustWetFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faConStandWater,
                                  value: ((state.corrections.conditionFactorStandingWater - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustStandingWaterFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faConSlush,
                                  value: ((state.corrections.conditionFactorSlush - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustSlushFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faConWetSnow,
                                  value: ((state.corrections.conditionFactorWetSnow - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustWetSnowFactor(factor: value),
                                ),
                                const SizedBox(height: 16),
                                FactorAdjustField(
                                  message: Localizer.of(context).faConDrySnow,
                                  value: ((state.corrections.conditionFactorDrySnow - 1) * 100).round(),
                                  onFactorSet: (value) => context.read<FactorAdjustCubit>().adjustDrySnowFactor(factor: value),
                                  isLastInGroup: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                )
            );
          },
        ),
      ),
    );
  }
}

///Used internally in the [FactorAdjustPanel] and [FactorAdjustCubit] to track the current state.
class FactorAdjustState{

  FactorAdjustState._({required this.corrections});
  factory FactorAdjustState.initial({required Corrections corrections}) => FactorAdjustState._(corrections: corrections.copy());

  final Corrections corrections;

  FactorAdjustState copyWidth({Corrections? corrections}){
    return FactorAdjustState._(corrections: corrections ?? this.corrections);
  }
}

///Handles all the logic of the [FactorAdjustPanel].
///All "Adjust" functions will require a factor parameter, that is if null reset to the
///standard value of the respective factor.
class FactorAdjustCubit extends Cubit<FactorAdjustState>{
  FactorAdjustCubit({Corrections? corrections}) : super(FactorAdjustState.initial(corrections: corrections ?? Corrections()));

  ///if called, will reset all factors to the standard.
  void reset(){
    return emit(state.copyWidth(corrections: Corrections()));
  }

  //region Winds
  void adjustHeadwindFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..headWindFactor = Corrections().headWindFactor));
    return emit(state.copyWidth(corrections: state.corrections.copy()..headWindFactor = factor));
  }

  void adjustTailwindFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..tailWindFactor = Corrections().tailWindFactor));
    return emit(state.copyWidth(corrections: state.corrections.copy()..tailWindFactor = factor));
  }
  //endregion
  //region Grass
  void adjustGrassFirmFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..grassFactorFirm = Corrections().grassFactorFirm));
    return emit(state.copyWidth(corrections: state.corrections.copy()..grassFactorFirm = factor));
  }

  void adjustGrassWetFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..grassFactorWet = Corrections().grassFactorWet));
    return emit(state.copyWidth(corrections: state.corrections.copy()..grassFactorWet = factor));
  }

  void adjustGrassSoftenedFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..grassFactorSoftened = Corrections().grassFactorSoftened));
    return emit(state.copyWidth(corrections: state.corrections.copy()..grassFactorSoftened = factor));
  }

  void adjustSodDamagedFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..sodDamagedFactor = Corrections().sodDamagedFactor));
    return emit(state.copyWidth(corrections: state.corrections.copy()..sodDamagedFactor = factor));
  }

  void adjustHighGrassFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..highGrassFactor = Corrections().highGrassFactor));
    return emit(state.copyWidth(corrections: state.corrections.copy()..highGrassFactor = factor));
  }
  //endregion
  //region RWY Condition
  void adjustWetFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorWet = Corrections().conditionFactorWet));
    return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorWet = factor));
  }
  void adjustStandingWaterFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorStandingWater = Corrections().conditionFactorStandingWater));
    return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorStandingWater = factor));
  }
  void adjustSlushFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorSlush = Corrections().conditionFactorSlush));
    return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorSlush = factor));
  }
  void adjustWetSnowFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorWetSnow = Corrections().conditionFactorWetSnow));
    return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorWetSnow = factor));
  }
  void adjustDrySnowFactor({required double? factor}){
    if(factor == null) return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorDrySnow = Corrections().conditionFactorDrySnow));
    return emit(state.copyWidth(corrections: state.corrections.copy()..conditionFactorDrySnow = factor));
  }
  //endregion
}

