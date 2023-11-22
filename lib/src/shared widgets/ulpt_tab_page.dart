import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///Tab Page with arrows for navigation on desktop
class ULPTTabPage extends StatefulWidget {
  const ULPTTabPage({
    super.key,
    required this.widgets,
    this.theme = const TabPageTheme()
  });

  ///Pages of the tab view
  final List<Widget> widgets;
  ///Can be overridden, to make use of a different theme than standard.
  final TabPageTheme theme;

  @override
  State<ULPTTabPage> createState() => _ULPTTabPageState();
}

class TabPageTheme{
  const TabPageTheme({
    this.arrowColor = Colors.white,
    this.dotColor = Colors.white,
  });

  final Color arrowColor;
  final Color dotColor;
}

class _ULPTTabPageState extends State<ULPTTabPage> with TickerProviderStateMixin{

  late final PageController pageController;
  late final TabController tabController;
  final pageAnimationDuration = const Duration(milliseconds: 500);
  final pageCurve = Curves.ease;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
    tabController = TabController(length: widget.widgets.length, vsync: this);
  }

  void rebuildAfterFrame() async{
    await SchedulerBinding.instance.endOfFrame;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    tabController.dispose();
  }

  void selectNextPage() async{
    await pageController.nextPage(duration: pageAnimationDuration, curve: pageCurve);
    setState(() {tabController.index = pageController.page!.toInt();});
  }

  void selectPreviousPage() async{
    await pageController.previousPage(duration: pageAnimationDuration, curve: pageCurve);
    setState(() {tabController.index = pageController.page!.toInt();});
  }

  void onPageChanged(int newPage){
    currentPage = newPage;
    tabController.index = newPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: widget.widgets,
        ),
        if(widget.widgets.length > 1 && currentPage != 0)
          Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  color: widget.theme.arrowColor,
                  onPressed: selectPreviousPage,
                  icon: const Icon(Icons.arrow_back)
              )
          ),
        if(widget.widgets.length > 1 && currentPage != widget.widgets.length - 1)
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  color: widget.theme.arrowColor,
                  onPressed: selectNextPage,
                  icon: const Icon(Icons.arrow_forward)
              )
          ),
        if(widget.widgets.length > 1)
          Align(
            alignment: Alignment.bottomCenter,
            child: TabPageSelector(
              selectedColor: widget.theme.dotColor,
              controller: tabController,
            ),
          )
      ],
    );
  }
}
