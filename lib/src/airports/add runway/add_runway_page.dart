import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_button.dart';
import 'BLoC/add_runway_bloc.dart';
import 'widgets/widgets.dart';

class AddRunwayPage extends StatelessWidget {
  const AddRunwayPage({super.key, this.original});

  ///if non null page is in edit mode.
  final Runway? original;

  @override
  Widget build(BuildContext context) {

    var dict = Localizer.of(context);

    return BlocProvider<AddRunwayCubit>(
      create: (context) => AddRunwayCubit(original: original),
      child: BlocBuilder<AddRunwayCubit, AddRunwayState>(
        builder: (context, state) {

          var cubit = context.read<AddRunwayCubit>();

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: original == null ? Text(dict.rwyAddTitle) : Text(dict.rwyEditTitle),
              leading: BackButton(onPressed: () => cubit.onClose(context: context),),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        DesignatorEntry(
                          value: state.designator,
                          onDesignatorSet: (d) => cubit.setDesignator(designator: d),
                        ),
                        const SizedBox(height: 8,),
                        RunwayCourseEntry(
                          value: state.direction,
                          onCourseSet: (d) => cubit.setDirection(direction: d),
                        ),
                        const SizedBox(height: 8,),
                        RunwaySurfaceDropdown(
                          value: state.surface,
                          onSurfaceChanged: (s) => cubit.setSurface(surface: s),
                        ),
                        const SizedBox(height: 8,),
                        RunwayElevationEntry(
                          value: state.startElevation,
                          onElevationSet: (e) => cubit.setStartElevation(elevation: e),
                        ),
                        const SizedBox(height: 8,),
                        RunwayElevationEntry(
                            value: state.endElevation,
                            onElevationSet: (e) => cubit.setEndElevation(elevation: e),
                            endElev: true
                        ),
                        const SizedBox(height: 8,),
                        RunwaySlopeEntry(
                          value: state.slope,
                          onSlopeSet: (s) => cubit.setSlope(slope: s),
                        ),
                        const SizedBox(height: 8,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.intersections == null ? 1 : state.intersections!.length + 1,
                          itemBuilder: (context, index) {
                            bool isAdd = state.intersections == null || index == state.intersections!.length;

                            if(isAdd) return const _AddIntersect();
                            if(index == 0) {
                              return _NonEditableIntersect(
                                intersection: state.intersections!.first,
                              );
                            }

                            return _EditableIntersect(
                              intersection: state.intersections![index],
                            );
                          },
                        ),
                        const SizedBox(height: 16,),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 100),
                          child: ULPTButton(
                            enabled: cubit.canSave(),
                            title: dict.save,
                            onTap: () => cubit.save(context: context),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NonEditableIntersect extends StatelessWidget {
  const _NonEditableIntersect({required this.intersection});

  final Intersection intersection;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<AddRunwayCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Localizer.of(context).full),
              const SizedBox(height: 8,),
              IntersectionTodEntry(
                  value: intersection.toda > 0 ? intersection.toda : null,
                  onTodSet: (tod) => cubit.setIntersectionTOD(intersection: intersection, tod: tod)
              ),
            ],
          ),
        ),
        const SizedBox(height: 8,)
      ],
    );
  }
}

class _EditableIntersect extends StatelessWidget {
  const _EditableIntersect({
    required this.intersection,
  });

  final Intersection intersection;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<AddRunwayCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DesignatorEntry(
                  value: intersection.designator.isEmpty ? null : intersection.designator,
                  onDesignatorSet: (d) => cubit.setIntersectionDesignator(intersection: intersection, designator: d),
                  isIntersect: true,
              ),
              const SizedBox(height: 8,),
              IntersectionTodEntry(
                  value: intersection.toda > 0 ? intersection.toda : null,
                  onTodSet: (tod) => cubit.setIntersectionTOD(intersection: intersection, tod: tod)
              ),
              const SizedBox(height: 8,),
              IconButton(
                  onPressed: () => cubit.deleteIntersection(context: context, intersection: intersection),
                  icon: Icon(Icons.delete, color: Theme.of(context).listTileTheme.titleTextStyle!.color,)
              )
            ],
          ),
        ),
        const SizedBox(height: 8,),
      ],
    );
  }
}

class _AddIntersect extends StatelessWidget {
  const _AddIntersect();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Icon(Icons.add, color: Theme.of(context).listTileTheme.titleTextStyle!.color,),
      onTap: context.read<AddRunwayCubit>().addIntersection,
    );
  }
}


