import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/BLoC/calculation_bloc.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_button.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_min_size_scrollview.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'widgets/widgets.dart';

class PerformanceCalculationPanel extends StatelessWidget {
  const PerformanceCalculationPanel({
    super.key,
    required this.aircraft,
    required this.airportsList,
    this.panelHeight = 320,
  });

  ///Selected aircraft that is used for calculation
  final Aircraft aircraft;
  ///List of selectable airports
  final List<Airport> airportsList;
  ///Used for layout. If larger than the screen height will impose scrolling mechanics.
  final double panelHeight;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {

        var width = constraints.maxWidth;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(aircraft.name),
          ),
          body: SafeArea(
            child: BlocProvider<CalculationCubit>(
                create: (context) => CalculationCubit(aircraft: aircraft),
                child: BlocBuilder<CalculationCubit, CalculationState>(
                  builder: (context, state) {
                    return Padding(
                      padding: Platform.isIOS ? const EdgeInsets.fromLTRB(16, 4, 16, 24) :
                      const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: width >= 940 ?
                      _LargeSizedScreen(panelHeight: panelHeight, state: state, airports: airportsList)
                          : width >= 705 ? _MediumSizedScreen(panelHeight: panelHeight, state: state, airports: airportsList,)
                          : _SmallSizedScreen(
                          panelHeight:
                          state.runway != null && state.runway!.surface == Surface.grass ? panelHeight * 1.8 : panelHeight * 1.3,
                          state: state, airports: airportsList
                      ),
                    );
                  },
                )
            ),
          ),
        );
      },
    );
  }
}

class _LargeSizedScreen extends StatelessWidget {
  const _LargeSizedScreen({
    required this.panelHeight,
    required this.state,
    required this.airports
  });

  final double panelHeight;
  final CalculationState state;
  final List<Airport> airports;

  @override
  Widget build(BuildContext context) {
    return ULPTMinSizeScrollView(
      scrollController: context.read<CalculationCubit>().scrollControl,
      minHeight: 550,
      child: Column(
        children: [
          DetailsButtons(state: state),
          SizedBox(
            height: panelHeight,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _EntryPanelComponent(
                    state: state,
                    airportsList: airports,
                    padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _ButtonComponent(
                    state: state,
                    padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: _ResultPanelComponent(
                state: state,
              )
          ),
        ],
      ),
    );
  }
}

class _MediumSizedScreen extends StatelessWidget {
  const _MediumSizedScreen({
    required this.panelHeight,
    required this.state,
    required this.airports
  });

  final double panelHeight;
  final CalculationState state;
  final List<Airport> airports;

  @override
  Widget build(BuildContext context) {
    return ULPTMinSizeScrollView(
      scrollController: context.read<CalculationCubit>().scrollControl,
      minHeight: 650,
      child: Column(
        children: [
          DetailsButtons(state: state,),
          SizedBox(
            height: panelHeight,
            child: _EntryPanelComponent(
              state: state,
              airportsList: airports,
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
          ),
          SizedBox(
            height: 70,
            child: _ButtonComponent(
              state: state,
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
          ),
          Expanded(
              child: _ResultPanelComponent(
                state: state,
              )
          ),
        ],
      ),
    );
  }
}

class _SmallSizedScreen extends StatelessWidget {
  const _SmallSizedScreen({
    required this.panelHeight,
    required this.state,
    required this.airports
  });

  final double panelHeight;
  final CalculationState state;
  final List<Airport> airports;

  @override
  Widget build(BuildContext context) {
    return ULPTMinSizeScrollView(
      scrollController: context.read<CalculationCubit>().scrollControl,
      minHeight: 1050,
      child: Column(
        children: [
          DetailsButtons(
              isSmallSize: true,
              state: state,
          ),
          SizedBox(
            height: panelHeight,
            child: _EntryPanelComponent(
              state: state,
              airportsList: airports,
              isSmallSize: true,
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            ),
          ),
          SizedBox(
            height: 80,
            child: _ButtonComponent(
              state: state,
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            ),
          ),
          Expanded(
              child: _ResultPanelComponent(
                state: state,
                isSmallSize: true,
              )
          ),
        ],
      ),
    );
  }
}



class _ButtonComponent extends StatelessWidget {
  const _ButtonComponent({
    required this.state,
    required this.padding,
  });

  final CalculationState state;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<CalculationCubit>();
    //Todo can calc from state otherwise strange vis

    return Card(
      margin: padding,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ULPTButton(
            onTap: () => cubit.calculate(context: context),
            title: Localizer.of(context).pcCalc,
            enabled: cubit.canCalc,
          )
        ),
      ),
    );
  }
}

class _EntryPanelComponent extends StatelessWidget {
  const _EntryPanelComponent({
    required this.state,
    required this.airportsList,
    required this.padding,
    this.isSmallSize = false,
  });

  final List<Airport> airportsList;
  final CalculationState state;
  final bool isSmallSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: padding,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isSmallSize ? _SmallEntryPanel(state: state, airportsList: airportsList,)
            : _LargeEntryPanel(state: state, airportsList: airportsList,)
      ),
    );
  }
}

class _LargeEntryPanel extends StatelessWidget {
  const _LargeEntryPanel({required this.airportsList, required this.state});

  final List<Airport> airportsList;
  final CalculationState state;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<CalculationCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              APSelectDropDown(
                  airportList: airportsList,
                  value: state.airport,
                  onAirportSet: (ap) => cubit.setAirport(airport: ap)
              ),
              const SizedBox(height: 8,),
              RwySelectDropdown(
                value: state.runway,
                airport: state.airport,
                onRunwayChanged: (rwy) => cubit.setRunway(runway: rwy),
              ),
              const SizedBox(height: 8,),
              IntersectionSelectDropdown(
                value: state.intersection,
                runway: state.runway,
                onIntersectionChanged: (intersect) => cubit.setIntersection(intersection: intersect),
              ),
              const SizedBox(height: 8,),
              if(state.runway?.surface == Surface.grass) GrassConditionDropdown(
                value: state.underground,
                runway: state.runway,
              ),
              if(state.runway?.surface == Surface.grass) const SizedBox(height: 8,),
              if(state.runway?.surface == Surface.grass) SodSelect(value: state.sodDamaged),
              if(state.runway?.surface == Surface.grass) const SizedBox(height: 8,),
              if(state.runway?.surface == Surface.grass) HighGrass(value: state.highGrass),
            ],
          ),
        ),
        const SizedBox(width: 16,),
        Expanded(
          child: FocusTraversalGroup(
            child: Column(
              children: [
                RunwayConditionDropdown(
                  condition: state.runwayCondition,
                  onConditionChanged: (cond) => cubit.setRunwayCondition(condition: cond),
                ),
                const SizedBox(height: 8,),
                TemperatureEntryField(
                    value: state.temp,
                    onTempSet: (temp) => cubit.setTemperature(temp: temp)
                ),
                const SizedBox(height: 8,),
                WindEntryField(
                  onWindSet: (wind) => cubit.setWind(wind: wind),
                  value: state.wind,
                  runwayCourse: state.runway?.direction,
                ),
                const SizedBox(height: 8,),
                QNHEntryField(
                    value: state.qnh,
                    onQNHSet: (qnh) => cubit.setQNH(qnh: qnh),
                ),
                const SizedBox(height: 8,),
                SafetyFactorEntryField(
                    value: state.safetyFactor,
                    onFactorSet: (fac) => cubit.setSafetyFactor(factor: fac),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallEntryPanel extends StatelessWidget {
  const _SmallEntryPanel({required this.airportsList, required this.state});

  final List<Airport> airportsList;
  final CalculationState state;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<CalculationCubit>();

    return Column(
      children: [
        APSelectDropDown(
            airportList: airportsList,
            value: state.airport,
            onAirportSet: (ap) => cubit.setAirport(airport: ap),
        ),
        const SizedBox(height: 8,),
        RwySelectDropdown(
          value: state.runway,
          airport: state.airport,
          onRunwayChanged: (rwy) => cubit.setRunway(runway: rwy),
        ),
        const SizedBox(height: 8,),
        IntersectionSelectDropdown(
          value: state.intersection,
          runway: state.runway,
          onIntersectionChanged: (intersect) => cubit.setIntersection(intersection: intersect),
        ),
        const SizedBox(height: 8,),
        if(state.runway?.surface == Surface.grass) GrassConditionDropdown(
          value: state.underground,
          runway: state.runway,
        ),
        if(state.runway?.surface == Surface.grass) const SizedBox(height: 8,),
        if(state.runway?.surface == Surface.grass) SodSelect(value: state.sodDamaged),
        if(state.runway?.surface == Surface.grass) const SizedBox(height: 8,),
        if(state.runway?.surface == Surface.grass) HighGrass(value: state.highGrass),
        if(state.runway?.surface == Surface.grass) const SizedBox(height: 8,),
        RunwayConditionDropdown(
          condition: state.runwayCondition,
          onConditionChanged: (cond) => cubit.setRunwayCondition(condition: cond),
          isSmallSize: true,
        ),
        const SizedBox(height: 8,),
        TemperatureEntryField(
            value: state.temp,
            onTempSet: (temp) => cubit.setTemperature(temp: temp),
            isSmallSize: true,
        ),
        const SizedBox(height: 8,),
        WindEntryField(
          onWindSet: (wind) => cubit.setWind(wind: wind),
          value: state.wind,
          runwayCourse: state.runway?.direction,
          isSmallSize: true,
        ),
        const SizedBox(height: 8,),
        QNHEntryField(
            value: state.qnh,
            onQNHSet: (qnh) => cubit.setQNH(qnh: qnh),
            isSmallSize: true,
        ),
        const SizedBox(height: 8,),
        SafetyFactorEntryField(
            value: state.safetyFactor,
            onFactorSet: (fac) => cubit.setSafetyFactor(factor: fac),
            isSmallSize: true,
        ),
      ],
    );
  }
}


class _ResultPanelComponent extends StatelessWidget {
  const _ResultPanelComponent({
    required this.state,
    this.isSmallSize = false,
  });

  final CalculationState state;
  final bool isSmallSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: isSmallSize ? const EdgeInsets.all(2) : const EdgeInsets.fromLTRB(4, 2, 4, 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Center(
          child: Results(
            isSmallSize: isSmallSize,
            rawTOD: state.rawTod,
            factorizedTod: state.factorizedTod,
            availTod: state.intersection?.toda,
          )
        ),
      ),
    );
  }
}





